//
//  DistanceService.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
struct DistanceServices {
    
    static let apiKey = "AIzaSyDP_vdpdBSqJobAnUOJTz-hlYKlHKQwDYw"
    
    static func findDistance(startLat: Double, startLng: Double, coordinates: [String], completion: @escaping ([Double]) -> Void) {
        let coordString = coordinates.joined(separator: "|")
        
        let parameters = ["key":apiKey,"origins":"\(startLat),\(startLng)","destinations":coordString,"mode":"walking","units":"imperial"]
        
        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            var distances = [Double]()
            for route in response["rows"][0]["elements"].arrayValue {
                distances.append(route["distance"]["value"].doubleValue)
            }
            completion(distances)
        }
    }
}
