//
//  DirectionsServices.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/1/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DirectionsServices {
    static let apiKey = "AIzaSyDP_vdpdBSqJobAnUOJTz-hlYKlHKQwDYw"
    
    static func findRoundTripRoute(startLat: Double, startLng: Double, waypointLat: Double, waypointLng: Double, travelMode: String, completion: @escaping (Double) -> Void) {

        let parameters = ["key":apiKey,"origin":"37.7808727,-122.4183261","destination":"37.7808727,-122.4183261","mode":travelMode,"units":"imperial","waypoints":"\(waypointLat),\(waypointLng)"]

        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            let distance = response["routes"][0]["legs"][0]["distance"]["value"].doubleValue
            completion(distance*2)
        }
    }
    
}
