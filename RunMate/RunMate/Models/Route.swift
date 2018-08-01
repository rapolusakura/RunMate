//
//  Route.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

struct Route {
    let name: String
    let startLat: Double
    let startLng: Double
    let endLat: Double
    let endLng: Double
    let distance: Double
    var isOneWay: Bool = true
    
    init(name: String, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double){
        self.name = name
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.distance = distance
    }
    
    init(name: String, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, isOneWay: Bool){
        self.name = name
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.distance = distance
        self.isOneWay = isOneWay
    }
    
    func convertCoordToString(lat: Double, lng: Double) -> String {
        return "\(lat),\(lng)"
    }
}
