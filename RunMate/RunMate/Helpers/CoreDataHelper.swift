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
    
    static func createRoute(place: Location, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, travelMode: String, elevation: Double) -> Trip {
        let route = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as! Trip
        route.place = place
        route.distance = distance
        route.startLat = startLat
        route.startLng = startLng
        route.endLat = endLat
        route.endLng = endLng
        route.travelMode = travelMode
        route.dateCompleted = Date()
        route.isOneWay = true
        route.elevation = elevation
        
        return route
    }
    
    static func createRoute(place: Location, startLat: Double, startLng: Double, endLat: Double, endLng: Double, distance: Double, isOneWay: Bool, travelMode: String) -> Trip {
        let route = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as! Trip
        route.place = place
        route.distance = distance
        route.startLat = startLat
        route.startLng = startLng
        route.endLat = endLat
        route.endLng = endLng
        route.travelMode = travelMode
        route.dateCompleted = Date()
        route.isOneWay = isOneWay
        
        return route
    }
    
    static func createPlace(imageURL: String, name: String, rating: Double, lat: Double, lng: Double, distance: Double, types: [String]) -> Location {
        let place = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
        place.imageURL = imageURL
        place.name = name
        place.rating = rating
        place.lat = lat
        place.lng = lng
        place.distance = distance
        place.types = types as NSObject
        
        return place
    }
    
    static func saveRoute() -> Void {
        do{
            try context.save()
        } catch let error {
            print("could not save \(error.localizedDescription)")
        }
    }
    
    static func deletePlace(place: Location) {
        context.delete(place)
    }
    
    static func retrieveRoutes() -> [Trip] {
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCompleted", ascending: false)]
        do{
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("could not save \(error.localizedDescription)")
            return []
        }
    }
}