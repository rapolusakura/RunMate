//
//  CoreDataHelper.swift
//  RunMate
//
//  Created by Sakura Rapolu on 8/5/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func createTrip() -> Trip {
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as! Trip
        return trip
    }
    
    static func saveTrip() -> Void {
        do{
            try context.save()
        } catch let error {
            print("could not save \(error.localizedDescription)")
        }
    }
    
    static func retrieveTrips() -> [Trip] {
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        do{
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("could not save \(error.localizedDescription)")
            return []
        }
    }
}
