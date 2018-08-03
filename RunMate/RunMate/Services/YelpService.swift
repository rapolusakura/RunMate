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
    
    static func getPitStops(lat: Double, lng: Double) {
        let apiToContact = "https://api.yelp.com/v3/businesses/search?attributes=gender_neutral_restrooms&radius=300&sort_by=distance&latitude=\(lat)&longitude=\(lng)&limit=5&open_now=true"
        
        guard let url = URL(string: apiToContact) else {return assertionFailure("URL Failed")}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer 704azzpEPQYj74YGBz1mwE0yp96vB5VjV9ytQluciKI0EC46ZA6kprJMwgml2ffxqPngLUmlkh2jBK6t3c4eOcMqPSjvyurPthNZo1jyS-HgBfUl2bYsTVUQPJFkW3Yx", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    print(json)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
}
