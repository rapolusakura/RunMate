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
    
    static func findRoundTripRoute(startLat: Double, startLng: Double, waypointLat: Double, waypointLng: Double, completion: @escaping (Double) -> Void) {

        let parameters = ["key":apiKey,"origin":"37.7808727,-122.4183261","destination":"37.7808727,-122.4183261","mode":"walking","units":"imperial","waypoints":"37.7917188,-122.4468661"]

        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            print("Getting final distance")
            let response = try! JSON(data: response.data!)
            let distance = response["routes"][0]["legs"][0]["distance"]["value"].doubleValue
            print("FINAL DISTANCE: \(distance)")
            completion(distance*2)
        }
    }
    
}
