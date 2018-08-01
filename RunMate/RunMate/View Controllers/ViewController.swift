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
        PlacesService.findNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance) { (routes) in
            self.performSegue(withIdentifier: "viewResults", sender: routes)
        }
    }
    
    @IBOutlet weak var distanceTextField: UITextField!
    
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

