//
//  PreviousRoutesViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/5/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class PreviousRouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var routes: [Trip]?
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routes!.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowPastRoutesTableViewCell
        let route = routes![indexPath.section]
        cell.routeNameLabel.text = route.place?.name
        cell.routeDistanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
            + " mi"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: route.dateCompleted!)
        cell.dateCompletedLabel.text = result
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes![indexPath.section]
        self.performSegue(withIdentifier: "showRouteDetails", sender: route)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showRouteDetails":
            let trip = sender as! Trip
            print("the trip elevation is", trip.elevation)
            let place = Place(placeId: (trip.place?.placeId)!, imageURL: (trip.place?.imageURL)!, name: (trip.place?.name)!, rating: (trip.place?.rating)!, numRatings: (trip.place?.numRatings)!,  lat: (trip.place?.lat)!, lng: (trip.place!.lng), distance: trip.distance)
            let route = Route(place: place, startLat: trip.startLat, startLng: trip.startLng, endLat: trip.endLat, endLng: trip.endLng, distance: trip.distance, isOneWay: trip.isOneWay, travelMode: trip.travelMode!, elevation: trip.elevation)
            let destination = segue.destination as! ShowRouteViewController
            destination.route = route
        default:
            print("i dont recognize this")
        }
    }
    
}
