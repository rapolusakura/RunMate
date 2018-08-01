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
        cell.placeNameLabel.text = route.name
        cell.distanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
        + " mi"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showPlaceDetails":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let route = routes[indexPath.row]
            let destination = segue.destination as! ShowRouteViewController
            destination.route = route
//            destination.routeNameLabel.text = route.name
//            destination.routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
//                + " mi"
        default:
            print("i dont recognize this")
        }
    }
    
    
}
