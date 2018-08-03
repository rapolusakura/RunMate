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
        let apiToContact = "https://api.yelp.com/v3/businesses/search?term=tourist_attractions&location=chicago,il"
        guard let url = URL(string: apiToContact) else {return assertionFailure("URL Failed")}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer 704azzpEPQYj74YGBz1mwE0yp96vB5VjV9ytQluciKI0EC46ZA6kprJMwgml2ffxqPngLUmlkh2jBK6t3c4eOcMqPSjvyurPthNZo1jyS-HgBfUl2bYsTVUQPJFkW3Yx", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    print(json)
                    
                }
            case .failure(let error):
                print(error)
            }
        // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    @IBAction func viewResultsButton(_ sender: Any) {
        let miles = Double(distanceTextField.text!)!
        let distance = Conversion.milestoMeters(miles: miles) //distance in meters
        //hardcoded location, need to update!
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
        default:
            PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance, travelMode: travelMode) { (routes) in
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

