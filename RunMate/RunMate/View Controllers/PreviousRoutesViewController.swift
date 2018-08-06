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
        print(routes!.count) 
        return routes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowPastRoutesTableViewCell
        let route = routes![indexPath.row]
        cell.routeNameLabel.text = route.place?.name
        return cell
    }
    
}
