//
//  ViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewResultsButton(_ sender: Any) {
        let miles = Double(distanceTextField.text!)!
        let distance = Conversion.milestoMeters(miles: miles) //distance in meters
        //hardcoded location, need to update!
        //,
        YelpService.getPitStops(lat: 37.7808727, lng: -122.4183261, radius: distance)
//        let travelModeIndex = travelModeSegmentedControl.selectedSegmentIndex
//        let travelMode: String
//        switch travelModeIndex {
//        case 1:
//            travelMode = "bicycling"
//        default:
//            travelMode = "walking"
//        }
//        let tripSettingIndex = tripSettingSegmentedControl.selectedSegmentIndex
//        switch tripSettingIndex {
//        case 1:
//            PlacesService.findRoundTripNearbyPlaces(lat: 37.7808727, lng: -122.4183261, originalRadius: distance, travelMode: travelMode) { (routes) in
//                self.performSegue(withIdentifier: "viewResults", sender: routes)
//            }
//        default:
//            PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance, travelMode: travelMode) { (routes) in
//                self.performSegue(withIdentifier: "viewResults", sender: routes)
//            }
//        }
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

