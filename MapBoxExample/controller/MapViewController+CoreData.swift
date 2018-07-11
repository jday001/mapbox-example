//
//  MapViewController+CoreData.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import UIKit
import CoreData


extension MapViewController {
    
    func fetchPins() {
        let request = NSFetchRequest<MapPin>(entityName: "MapPin")
        
        guard let pins = try? CoreDataManager.shared.mainContext.fetch(request) else {
            return
        }
        
        for pin in pins {
            let coordinate = Coordinate(latitude: pin.latitude, longitude: pin.longitude)
            let mapLocation = MapLocation(coordinate: coordinate, elevation: pin.elevation)
            self.addAnnotation(for: mapLocation)
        }
    }
    
    func save(_ mapLocation: MapLocation) {
        let mapPin = NSEntityDescription.insertNewObject(forEntityName: "MapPin",
                                                         into: CoreDataManager.shared.mainContext)
        if let pin = mapPin as? MapPin {
            pin.latitude = mapLocation.coordinate.latitude
            pin.longitude = mapLocation.coordinate.longitude
            pin.elevation = mapLocation.elevation
            
            CoreDataManager.shared.save()
        }
    }
    
    func delete(_ mapLocation: MapLocation) {
        let request = NSFetchRequest<MapPin>(entityName: "MapPin")
        
        do {
            let pins = try CoreDataManager.shared.mainContext.fetch(request)
            let pinsToDelete = pins.filter({ (pin) -> Bool in
                return pin.latitude == mapLocation.coordinate.latitude
                    && pin.longitude == mapLocation.coordinate.longitude
            })
            
            for pinToDelete in pinsToDelete {
                CoreDataManager.shared.mainContext.delete(pinToDelete)
                CoreDataManager.shared.save()
            }
            
        } catch let error as NSError {
            print("CoreData deletion error: \(error.localizedDescription)")
        }
    }
}
