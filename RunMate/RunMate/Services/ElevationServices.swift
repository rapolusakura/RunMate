//
//  ElevationServices.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/2/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ElevationServices {
    static let apiKey = "AIzaSyDP_vdpdBSqJobAnUOJTz-hlYKlHKQwDYw"
    
    static func findElevationDifference(startLat: Double, startLng: Double, endLat: Double, endLng: Double, completion: @escaping (Double) -> Void) {
        let parameters = ["key":apiKey,"locations":"\(startLat),\(startLng)|\(endLat),\(endLng)"]
        
        Alamofire.request("https://maps.googleapis.com/maps/api/elevation/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            let startElevation: Double = response["results"][0]["elevation"].doubleValue
            let endElevation: Double = response["results"][1]["elevation"].doubleValue
            let elevationDifference: Double = endElevation - startElevation
            
            completion(elevationDifference)
        }
    }
    
    
}
