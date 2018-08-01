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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DisplayResultTableViewCell
        let route = routes[indexPath.row]
        cell.placeNameLabel.text = route.name
        cell.distanceLabel.text = String(route.distance)
        print(String(route.distance))
        return cell
    }
    
    
}
