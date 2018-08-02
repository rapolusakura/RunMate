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
    
    @IBAction func startRouteButtonPressed(_ sender: Any) {
        getDirections()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if let route = route {
            routeNameLabel.text = route.name
            routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
                + " mi"
        } else {
            routeNameLabel.text = ""
            routeDistanceLabel.text = ""
        }
        
    }
    
    func getDirections(){
        let coordinate = CLLocationCoordinate2DMake((route?.endLat)!, (route?.endLng)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = route?.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
}
