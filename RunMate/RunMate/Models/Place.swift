//
//  Place.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/2/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

class Place {
    var placeId: String = ""
    let name: String
    let rating: Double
    let lat: Double
    let lng: Double
    let distance: Double
    let types: [String]
    
    init(name: String, rating: Double, lat: Double, lng: Double, distance: Double, types: [String]){
        self.name = name
        self.rating = rating
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.types = types
    }
    
    init(placeId: String, name: String, rating: Double, lat: Double, lng: Double, distance: Double, types: [String]){
        self.name = name
        self.rating = rating
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.types = types
        self.placeId = placeId
    }
    
}
