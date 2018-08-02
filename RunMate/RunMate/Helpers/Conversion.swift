//
//  Conversion.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation

struct Conversion {
    static func metersToMiles(meters: Double) -> Double {
        return meters*0.000621371
    }
    
    static func milestoMeters(miles: Double) -> Double {
        return miles*1609.34
    }
    
    static func metersToFeet(meters: Double) -> Double {
        return meters*3.28084
    }
    
}
