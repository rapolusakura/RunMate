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
    
    static func findNearbyPlaces(lat: Double, lng: Double, radius: Double, completion: @escaping ([Route]) -> Void) {
        var routes = [Route]()
        var intermediate = [(String, Double, Double, Double?)]()
        var coordinates = [String]()
        let parameters = ["key":apiKey,"location":"\(lat),\(lng)","radius":"\(radius)","type":"park"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            for resp in response["results"].arrayValue {
                let name = resp["name"].stringValue
                let endLat = resp["geometry"]["location"]["lat"].doubleValue
                let endLng = resp["geometry"]["location"]["lng"].doubleValue
                intermediate.append((name, endLat, endLng, nil))
                coordinates.append("\(endLat),\(endLng)")
                //let route = Route(name: name, startLat: lat, startLng: lng, endLat: endLat, endLng: endLng)
                //routes.append(route)
            }
            DistanceServices.findDistance(startLat: lat, startLng: lng, coordinates: coordinates, completion: { (distances) in
                print(distances.count)
                print(intermediate.count)
                for i in 1...distances.count {
                    intermediate[i-1].3 = distances[i-1]
                }
                for rawRoute in intermediate {
                    let route = Route(name: rawRoute.0, startLat: lat, startLng: lng, endLat: rawRoute.1, endLng: rawRoute.2, distance: rawRoute.3!)
                    routes.append(route)
                }
                completion(routes)
            })
        }
    }
    
}
