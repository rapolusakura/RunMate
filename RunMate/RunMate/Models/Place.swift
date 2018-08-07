//
//  Place.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/2/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

struct Place {
    let imageURL: String
    let name: String
    let rating: Double
    let lat: Double
    let lng: Double
    let distance: Double
    let 
    
    init(placeID: String, name: String, rating: Double, lat: Double, lng: Double) {
        self.placeID = placeID
        self.name = name
        self.rating = rating
        self.lat = lat
        self.lng = lng
    }
}
