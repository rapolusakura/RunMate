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
            //not sorting by review count, default sort by best match
            var routes = [Route]()
            let integerRadius = Int(radius) + 500
            let apiToContact = "https://api.yelp.com/v3/businesses/search?radius=\(integerRadius)&latitude=\(lat)&longitude=\(lng)&categories=lakes,parks,publicplazas,parklets,publicart,communitygardens,forestry,landmarks,gardens,castles"
            
            guard let url = URL(string: apiToContact) else {return assertionFailure("URL Failed")}
            
            var request = URLRequest(url: url)
            request.setValue("Bearer 704azzpEPQYj74YGBz1mwE0yp96vB5VjV9ytQluciKI0EC46ZA6kprJMwgml2ffxqPngLUmlkh2jBK6t3c4eOcMqPSjvyurPthNZo1jyS-HgBfUl2bYsTVUQPJFkW3Yx", forHTTPHeaderField: "Authorization")
            
            Alamofire.request(request).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for business in json["businesses"].arrayValue {
                            let name = business["name"].stringValue
                            let endLat = business["coordinates"]["latitude"].doubleValue
                            let endLng = business["coordinates"]["longitude"].doubleValue
                            let rating = business["rating"].doubleValue
                            let distance = business["distance"].doubleValue //in meters
                            var types = [String]()
                            for category in business["categories"].arrayValue {
                                types.append(category["title"].stringValue)
                            }
                            let city = business["location"]["city"].stringValue
                            types.append(city)
                            let place = Place(name: name, rating: rating, lat: endLat, lng: endLng, distance: distance, types: types)
                            let route = Route(place: place, startLat: lat, startLng: lng, endLat: endLat, endLng: endLng, distance: distance, travelMode: travelMode)
                            routes.append(route)
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                routes = routes.sorted(by: {abs($0.distance - radius) < abs($1.distance - radius)})
                completion(routes)
            }
    }
    
    static func findRoundTripNearbyPlaces(lat: Double, lng: Double, originalRadius: Double, travelMode: String, completion: @escaping ([Route]) -> Void) {

        let radius = (originalRadius/2)+800
        var routes = [Route]()
        
        PlacesService.findOneWayNearbyPlaces(lat: lat, lng: lng, radius: radius, travelMode: travelMode) { (returnedRoutes) in
            routes = returnedRoutes
            for route in routes {
                route.distance*=2
            }
            routes = routes.sorted(by: {abs($0.distance - originalRadius) < abs($1.distance - originalRadius)})
            completion(routes)
        }
    }
    
    static func getCurrPlaceID(lat: Double, long: Double, name: String, city: String, completion: @escaping (String) -> Void) {
        print("\(city) \(name)")
        let parameters = ["key":apiKey,"point":"\(lat),\(long)","input":"\(city) \(name)","inputtype":"textquery"]
        Alamofire.request("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?", parameters: parameters).responseJSON(options:.mutableContainers) {pathData in
            let json = try! JSON(data: pathData.data!)
            let placeId = json["candidates"][0]["place_id"].stringValue
            print(json)
            completion(placeId)
            
        }
    }
}
