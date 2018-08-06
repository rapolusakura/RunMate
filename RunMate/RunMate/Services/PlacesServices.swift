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
    static let apiKey = Constants.apiKey
    
    static func findOneWayNearbyPlaces(lat: Double, lng: Double, radius: Double, travelMode: String, completion: @escaping ([Route]) -> Void) {
        var routes = [Route]()
        var intermediate = [(Place, Double, Double, Double?)]()
        var coordinates = [String]()
        let parameters = ["key":apiKey,"location":"\(lat),\(lng)","radius":"\(radius)","type":"park"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            for resp in response["results"].arrayValue {
                let name = resp["name"].stringValue
                let endLat = resp["geometry"]["location"]["lat"].doubleValue
                let endLng = resp["geometry"]["location"]["lng"].doubleValue
                let rating = resp["rating"].doubleValue
                let placeId = resp["place_id"].stringValue
                let place = Place(placeID: placeId, name: name, rating: rating, lat: endLat, lng: endLng)
//                let place = CoreDataHelper.createPlace(placeID: placeId, name: name, rating: rating, lat: endLat, lng: endLng)
                intermediate.append((place, endLat, endLng, nil))
                coordinates.append("\(endLat),\(endLng)")
            }
            DistanceServices.findDistance(startLat: lat, startLng: lng, coordinates: coordinates, travelMode: travelMode, completion: { (distances) in
                for i in 1...distances.count {
                    intermediate[i-1].3 = distances[i-1]
                }
                for rawRoute in intermediate {
//                    let route = CoreDataHelper.createRoute(place: rawRoute.0, startLat: lat, startLng: lng, endLat: rawRoute.1, endLng: rawRoute.2, distance: rawRoute.3!, travelMode: travelMode)
                    let route = Route(place: rawRoute.0, startLat: lat, startLng: lng, endLat: rawRoute.1, endLng: rawRoute.2, distance: rawRoute.3!, travelMode: travelMode)
                    routes.append(route)
                }
                
                routes = routes.sorted(by: {abs($0.distance - radius) < abs($1.distance - radius)})
                completion(routes)
            })
        }
    }
    
    static func findRoundTripNearbyPlaces(lat: Double, lng: Double, originalRadius: Double, travelMode: String, completion: @escaping ([Route]) -> Void) {
        let radius = (originalRadius/2)+300
        var routes = [Route]()
        var distance: Double = 0
        
        let parameters = ["key":apiKey,"location":"\(lat),\(lng)","radius":"\(radius)","type":"park"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?", parameters: parameters).responseJSON(options:.mutableContainers) { response in
            let response = try! JSON(data: response.data!)
            
            let dg = DispatchGroup()
            
            for resp in response["results"].arrayValue {
               // iterator.
                let name = resp["name"].stringValue
                let endLat = resp["geometry"]["location"]["lat"].doubleValue
                let endLng = resp["geometry"]["location"]["lng"].doubleValue
                let rating = resp["rating"].doubleValue
                let placeId = resp["place_id"].stringValue
                let place = Place(placeID: placeId, name: name, rating: rating, lat: endLat, lng: endLng)
//                let place = CoreDataHelper.createPlace(placeID: placeId, name: name, rating: rating, lat: endLat, lng: endLng)
                
                dg.enter()
                DirectionsServices.findRoundTripRoute(startLat: lat, startLng: lng, waypointLat: endLat, waypointLng: endLng, travelMode: travelMode, completion: { (responseDistance) in
                    distance = responseDistance
//                    let route = CoreDataHelper.createRoute(place: place, startLat: lat, startLng: lng, endLat: endLat, endLng: endLng, distance: distance, isOneWay: false, travelMode: travelMode)
                    let route = Route(place: place, startLat: lat, startLng: lng, endLat: endLat, endLng: endLng, distance: distance, isOneWay: false, travelMode: travelMode)
                    routes.append(route)
                    dg.leave()
                })
            }
            
            dg.notify(queue: DispatchQueue.main, execute: {
                routes = routes.sorted(by: {abs($0.distance - originalRadius) < abs($1.distance - originalRadius)})
                completion(routes)
            })
        }
    }
}
