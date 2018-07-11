//
//  MapViewController+Offline.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import UIKit
import Mapbox


extension MapViewController {
    
    func saveOfflineRegion(for mapLocation: MapLocation) {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL,
                                                 bounds: mapView.visibleCoordinateBounds,
                                                 fromZoomLevel: mapView.zoomLevel,
                                                 toZoomLevel: mapView.zoomLevel)
        let jsonEncoder = JSONEncoder()
        if let encodedLocation = try? jsonEncoder.encode(mapLocation) {
            MGLOfflineStorage.shared().addPack(for: region,
                                               withContext: encodedLocation,
                                               completionHandler: nil)
        }
    }
    
    func deleteOfflineRegion(for mapLocation: MapLocation) {
        let jsonEncoder = JSONEncoder()
        guard let encodedLocation = try? jsonEncoder.encode(mapLocation) else {
            return
        }
        
        if let packs = MGLOfflineStorage.shared().packs {
            let packsToRemove = packs.filter({ (pack) -> Bool in
                return pack.context == encodedLocation
            })
            
            for pack in packsToRemove {
                MGLOfflineStorage.shared().removePack(pack, withCompletionHandler: nil)
            }
        }
    }
}
