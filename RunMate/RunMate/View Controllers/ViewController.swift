//
//  ViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        print(CoreDataHelper.retrieveRoutes())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func viewResultsButton(_ sender: Any) {
        let miles = Double(distanceTextField.text!)!
        let distance = Conversion.milestoMeters(miles: miles) //distance in meters
        let coordinate = locationManager.location?.coordinate
        locationManager.stopUpdatingLocation()
        let travelModeIndex = travelModeSegmentedControl.selectedSegmentIndex
        let travelMode: String
        switch travelModeIndex {
        case 1:
            travelMode = "bicycling"
        default:
            travelMode = "walking"
        }
        let tripSettingIndex = tripSettingSegmentedControl.selectedSegmentIndex
        switch tripSettingIndex {
        case 1:
            PlacesService.findRoundTripNearbyPlaces(lat: 37.7808727, lng: -122.4183261, originalRadius: distance, travelMode: travelMode) { (routes) in
                self.performSegue(withIdentifier: "viewResults", sender: routes)
            }
//            PlacesService.findRoundTripNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, originalRadius: distance, travelMode: travelMode) { (routes) in
//                self.performSegue(withIdentifier: "viewResults", sender: routes)
//            }
        default:
            PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance, travelMode: travelMode) { (routes) in
                self.performSegue(withIdentifier: "viewResults", sender: routes)
            }
//            PlacesService.findOneWayNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, radius: distance, travelMode: travelMode) { (routes) in
//                self.performSegue(withIdentifier: "viewResults", sender: routes)
//            }
        }
    }
    
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var tripSettingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var travelModeSegmentedControl: UISegmentedControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "viewResults":
            let routes = sender as! [Route]
            let destination = segue.destination as! DisplayResultsViewController
            destination.routes = routes
            
        default:
            print("i dont recognize this")
        }
    }
    
}

