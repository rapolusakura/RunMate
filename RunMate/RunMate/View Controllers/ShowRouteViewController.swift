//
//  ShowRouteViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import CoreData

class ShowRouteViewController: UIViewController {
    var route: Route?
    
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var placeRatingLabel: UILabel!
    
    @IBOutlet weak var routeDistanceLabel: UILabel!
    
    @IBOutlet weak var routeElevationLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var startRouteOutlet: UIButton!
    
    @IBAction func startRouteButtonPressed(_ sender: Any) {
        let location: Location = CoreDataHelper.createPlace(placeId: route!.place.placeId, name: route!.place.name, rating: route!.place.rating, lat: route!.place.lat, lng: route!.place.lng, distance: route!.place.distance, imageURL: route!.place.imageURL, numRatings: route!.place.numRatings)
        let trip: Trip = CoreDataHelper.createRoute(place: location, startLat: (self.route?.startLat)!, startLng: self.route!.startLng, endLat: self.route!.endLat, endLng: self.route!.endLng, distance: self.route!.distance, travelMode: self.route!.travelMode, elevation: route!.elevation ?? 0.0)
        
        if !CoreDataHelper.isPreferenceSet() {
            let preferenceObject = CoreDataHelper.createPreferenceObject()
            presentMapsPreferenceAlert(prefObject: preferenceObject, completion: getDirections)
        } else {
            getDirections()
        }
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if let route = route {
            guard let elevation = route.elevation
                else {
                    return
            }
            routeNameLabel.text = route.place.name
            routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
                + " mi"
            if elevation > 0.0 {
                routeElevationLabel.text = "+\(String(format: "%.2f", Conversion.metersToFeet(meters: elevation)))" + " ft"
  //              routeElevationLabel.textColor = .green
            }
            else {
                routeElevationLabel.text = "\(String(format: "%.2f", Conversion.metersToFeet(meters: elevation)))" + " ft"
            }
            placeRatingLabel.text = String((route.place.rating)) + " ★ (" + String(Int(route.place.numRatings)) + " ratings)"
            
            if route.place.placeId != "" {
                loadFirstPhotoForPlace(placeID: (route.place.placeId))
            } else if route.place.imageURL != "" {
                imageView.imageFromUrl(urlString: route.place.imageURL)
            } else {
                //placeholder image
                imageView.image = UIImage(named: "image-not-found.png")
            }
            
        } else {
            routeNameLabel.text = ""
            routeDistanceLabel.text = ""
            routeElevationLabel.text = ""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        
        startRouteOutlet.layer.cornerRadius = 15
        startRouteOutlet.layer.masksToBounds = true
        
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }

    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.imageView.image = photo;
                //self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func getDirections(){
        let lat: Double = (route?.endLat)!
        let lng: Double = (route?.endLng)!
        let travelMode: String = (route?.travelMode)!
        
        guard let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(String(lat)),\(String(lng))&travelmode=\(travelMode)")
            else { return }
        
        //&dir_action=navigate
        
        if CoreDataHelper.doesPreferGoogleMaps() {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let coordinate = CLLocationCoordinate2DMake((route?.endLat)!, (route?.endLng)!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = route?.place.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
        }
    }
    
    func presentMapsPreferenceAlert(prefObject: MapsPreference, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Select Preference for Maps App", message: "", preferredStyle: UIAlertControllerStyle.alert)

        // Create the actions
        let googleMaps = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.default) {
            UIAlertAction in
            prefObject.prefersGoogleMaps = true
            CoreDataHelper.saveRoute()
            completion()
        }
        
        let appleMaps = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.default) {
            UIAlertAction in
            prefObject.prefersGoogleMaps = false
            CoreDataHelper.saveRoute()
            completion()
        }
        
        // Add the actions
        alertController.addAction(googleMaps)
        alertController.addAction(appleMaps)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData as Data)
                }
            }
        }
    }
}
