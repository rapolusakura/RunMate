//
//  Route.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

class Route {
    let startLat: Double
    let startLng: Double
    let place: Place
    let endLat: Double
    let endLng: Double
    let distance: Double
    var isOneWay: Bool = true
    let travelMode: String
    var elevation: Double? = nil 
    
    init(place: Place, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, travelMode: String){
        self.place = place
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.distance = distance
        self.travelMode = travelMode
    }
    
    init(place: Place, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, isOneWay: Bool, travelMode: String){
        self.place = place
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.distance = distance
        self.isOneWay = isOneWay
        self.travelMode = travelMode
    }
    
    init(place: Place, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, isOneWay: Bool, travelMode: String, elevation: Double){
        self.place = place
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.distance = distance
        self.isOneWay = isOneWay
        self.travelMode = travelMode
        self.elevation = elevation
    }
}
