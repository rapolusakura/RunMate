//
//  PlacesServices.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct PlacesService {
    static let apiKey = "AIzaSyDP_vdpdBSqJobAnUOJTz-hlYKlHKQwDYw"
    
//    enum modeOfTransport: String {
//        typealias RawValue = String
//        case:
//    }
    
    static func findNearbyPlaces(lat: Double, lng: Double, radius: Double, completion: @escaping ([Route]) -> Void) {
        var routes = [Route]()
        let parameters = ["key":apiKey,"location":"\(lat), \(lng)","radius":"\(radius)","type":"park"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            for resp in response["results"].arrayValue {
                let name = resp["name"].stringValue
                let endLat = resp["geometry"]["location"]["lat"].doubleValue
                let endLng = resp["geometry"]["location"]["lng"].doubleValue
                let route = Route(name: name, startLat: lat, startLng: lng, endLat: endLat, endLng: endLng)
                routes.append(route)
            }
            //print(response)
            completion(routes)
        }
    }
    
}
