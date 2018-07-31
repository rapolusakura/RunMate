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
        self.performSegue(withIdentifier: "viewResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "viewResults":
            let destination = segue.destination as! DisplayResultsViewController
            let routes = PlacesService.findNearbyPlaces(lat: <#T##Double#>, lng: <#T##Double#>, radius: <#T##Double#>)
            //make the API call to the PlacesService and retrieve the array of results in a nicely formatted way.. that contains the information you want (create a struct?? for a 'place' as in a run?? and then you display the appropriate information!! 
            //destination.routes = self.results?
        default:
            print("i dont recognize this")
        }
    }
    
}

