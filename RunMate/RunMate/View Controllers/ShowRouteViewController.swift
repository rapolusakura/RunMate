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
import GooglePlaces

class ShowRouteViewController: UIViewController {
    var route: Route?
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var placeRatingLabel: UILabel!
    
    @IBOutlet weak var routeDistanceLabel: UILabel!
    
    @IBOutlet weak var routeElevationLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func startRouteButtonPressed(_ sender: Any) {
        getDirections()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if let route = route, let elevation = route.elevation {
            routeNameLabel.text = route.place.name
            routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
                + " mi"
            if elevation > 0 {
                routeElevationLabel.text = "+\(String(format: "%.2f", Conversion.metersToFeet(meters: elevation)))" + " ft"
                routeElevationLabel.textColor = .green
            }
            else {
                routeElevationLabel.textColor = .red
            }
            placeRatingLabel.text = String(route.place.rating) + " stars"

            loadFirstPhotoForPlace(placeID: route.place.placeID)
            
        } else {
            routeNameLabel.text = ""
            routeDistanceLabel.text = ""
            routeElevationLabel.text = ""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
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
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(route?.endLat),\(route?.endLng)&directionsmode=driving")! as URL)
        } else
        {
            print("Can't use com.google.maps://")
        }
    }
}
