//
//  DisplayResultsViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class DisplayResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routes = [Route]()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DisplayResultTableViewCell
        let route = routes[indexPath.row]
        cell.placeNameLabel.text = route.place.name
        cell.distanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
        + " mi"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showPlaceDetails":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            var route = routes[indexPath.row]
            ElevationServices.findElevationDifference(startLat: route.startLat, startLng: route.startLng, endLat: route.place.lat, endLng: route.place.lng) { (elevation) in
                route.elevation = elevation
            }
            let destination = segue.destination as! ShowRouteViewController
            destination.route = route
        default:
            print("i dont recognize this")
        }
    }
    
    
}
