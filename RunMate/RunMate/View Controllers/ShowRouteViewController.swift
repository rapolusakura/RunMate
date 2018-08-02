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

class ShowRouteViewController: UIViewController {
    var route: Route?
    
    @IBOutlet weak var routeNameLabel: UILabel!
    
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
            routeElevationLabel.text = String(format: "%.2f", Conversion.metersToFeet(meters: elevation)) + " ft"
            
        } else {
            routeNameLabel.text = ""
            routeDistanceLabel.text = ""
            routeElevationLabel.text = ""
        }
        
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
                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func getDirections(){
        let coordinate = CLLocationCoordinate2DMake((route?.endLat)!, (route?.endLng)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = route?.place.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
}
