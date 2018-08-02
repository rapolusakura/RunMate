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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func viewResultsButton(_ sender: Any) {
        let miles = Double(distanceTextField.text!)!
        let distance = miles*1609.34 //distance in meters
        //hardcoded location, need to update!
        let travelModeIndex = travelModeSegmentedControl.selectedSegmentIndex
        let tripSettingIndex = tripSettingSegmentedControl.selectedSegmentIndex
        switch tripSettingIndex {
        case 1:
            PlacesService.findRoundTripNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance) { (routes) in
                self.performSegue(withIdentifier: "viewResults", sender: routes)
            }
        default:
            PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance) { (routes) in
                self.performSegue(withIdentifier: "viewResults", sender: routes)
            }
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

