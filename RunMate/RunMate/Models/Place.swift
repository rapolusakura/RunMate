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
    let imageURL: String
    let numRatings: Double
    let name: String
    let rating: Double
    let lat: Double
    let lng: Double
    let distance: Double
    var city: String = ""
    
    init(name: String, rating: Double, numRatings: Double, lat: Double, lng: Double, distance: Double, imageURL: String, city: String){
        self.name = name
        self.rating = rating
        self.numRatings = numRatings
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.imageURL = imageURL
        self.city = city
    }
    
    init(placeId: String, imageURL: String, name: String, rating: Double, numRatings: Double, lat: Double, lng: Double, distance: Double){
        self.name = name
        self.rating = rating
        self.lat = lat
        self.lng = lng
        self.distance = distance
        self.placeId = placeId
        self.imageURL = imageURL
        self.numRatings = numRatings
    }
    
}
