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
    let apiKey = "AIzaSyDP_vdpdBSqJobAnUOJTz-hlYKlHKQwDYw"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parameters = ["key":apiKey,"location":"34.0254248,-118.2873805","radius":"3218.69","type":"park"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?", parameters: parameters).responseJSON(options:.mutableContainers) {response in
            let response = try! JSON(data: response.data!)
            print(response)
        }
    }
}

