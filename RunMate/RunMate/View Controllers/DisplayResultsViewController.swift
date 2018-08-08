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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropShadow(scale: true, sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DisplayResultTableViewCell
        let route = routes[indexPath.section]
        cell.placeNameLabel.text = route.place.name
        cell.distanceLabel.text = String(format: "%.2f", Conversion.metersToMiles(meters: route.distance))
        + " mi"
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.layer.shadowOffset = CGSize(width: 1, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes[indexPath.section]
        ElevationServices.findElevationDifference(startLat: route.startLat, startLng: route.startLng, endLat: (route.place.lat), endLng: (route.place.lng)) { (elevation) in
            route.elevation = elevation
            PlacesService.getCurrPlaceID(route: route, completion: { (placeId) in
                route.place.placeId = placeId
                self.performSegue(withIdentifier: "showPlaceDetails", sender: route)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showPlaceDetails":
            let route = sender as! Route
            let destination = segue.destination as! ShowRouteViewController
            destination.route = route
        default:
            print("i dont recognize this")
        }
    }
    
    func dropShadow(scale: Bool = true, sender: UIView) {
        sender.layer.masksToBounds = false
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOpacity = 0.6
        sender.layer.shadowOffset = CGSize(width: -1, height: 1)
        sender.layer.shadowRadius = 1.5
        sender.layer.shouldRasterize = true
        sender.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
