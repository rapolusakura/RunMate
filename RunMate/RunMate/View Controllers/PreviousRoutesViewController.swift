//
//  PreviousRoutesViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/5/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class PreviousRouteViewController: UITableViewController {
    var routes: [Trip]?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes!.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowPastRoutesTableViewCell
        let route = routes![indexPath.row]
        cell.routeNameLabel.text = route.place?.name
        cell.routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
            + " mi"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: route.dateCompleted!)
        cell.dateCompletedLabel.text = result
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes![indexPath.row]
        self.performSegue(withIdentifier: "showRouteDetails", sender: route)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showRouteDetails":
            let trip = sender as! Trip
            print("the trip elevation is", trip.elevation)
            let place = Place(placeId: (trip.place?.placeId)!, name: (trip.place?.name)!, rating: (trip.place?.rating)!, lat: (trip.place?.lat)!, lng: (trip.place!.lng), distance: trip.distance, types: (trip.place?.types)! as! [String])
            let route = Route(place: place, startLat: trip.startLat, startLng: trip.startLng, endLat: trip.endLat, endLng: trip.endLng, distance: trip.distance, isOneWay: trip.isOneWay, travelMode: trip.travelMode!, elevation: trip.elevation)
            let destination = segue.destination as! ShowRouteViewController
            destination.route = route
            print(route.elevation)
        default:
            print("i dont recognize this")
        }
    }
    
}
