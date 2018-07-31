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
    let endLng: Doube
    
    init(name: String, startLat: Double, startLng: Double, endLat: Double, endLng: Double){
        self.name = name
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
    }
}
