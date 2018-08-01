//
//  ShowRouteViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class ShowRouteViewController: UIViewController {
    var route = Route(name: "", startLat: 0, startLng: 0, endLat: 0, endLng: 0, distance: 0)
    
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var routeDistanceLabel: UILabel!
    
    
}
