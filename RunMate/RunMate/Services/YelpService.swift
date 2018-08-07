//
//  YelpService.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/3/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct YelpService {
    
    static func searchYelpPlaces(lat: Double, lng: Double, radius: Double, completion: @escaping ([YelpPlace]) -> Void) {
        //not sorting by review count, default sort by best match
        var yelpPlaces = [YelpPlace]()
        let apiToContact = "https://api.yelp.com/v3/businesses/search?radius=1600&latitude=\(lat)&longitude=\(lng)&categories=lakes,parks,publicplazas,parklets,publicart,communitygardens,forestry,landmarks,gardens,castles"

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
                        let lat = business["coordinates"]["latitude"].doubleValue
                        let lng = business["coordinates"]["longitude"].doubleValue
                        let rating = business["rating"].doubleValue
                        let distance = business["distance"].doubleValue //in meters
                        var types = [String]()
                        for category in business["categories"].arrayValue {
                            types.append(category["title"].stringValue)
                        }
                        let imageURL = business["image_url"].stringValue
                        let yelpPlace = YelpPlace(imageURL: imageURL, name: name, rating: rating, lat: lat, lng: lng, distance: distance, types: types)
                        yelpPlaces.append(yelpPlace)
                    }
                    print(json)
                }
            case .failure(let error):
                print(error)
            }
            completion(yelpPlaces)
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
}
