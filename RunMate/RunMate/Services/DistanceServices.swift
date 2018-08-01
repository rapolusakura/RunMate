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
    
    static func findDistance(routes: [Route], completion: @escaping (String, Double) -> Void) {
        var destLats = [String]()
        for route in routes {
            destLats.append(route.convertCoordToString(lat: route.endLat, lng: route.endLng))
        }
        let coordString = destLats.joined(separator: "|")
        
        let parameters = ["key":apiKey,"origins":"\(routes[0].startLat),\(routes[0].startLng)","destinations":coordString,"mode":"walking","units":"imperial"]
        
        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            print(response)
            let text = response["rows"][0]["elements"][0]["distance"]["text"].stringValue
            let distance = response["rows"][0]["elements"][0]["distance"]["value"].doubleValue
            completion(text, distance)
        }
    }
}
