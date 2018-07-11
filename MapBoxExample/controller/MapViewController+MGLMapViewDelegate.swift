//
//  MapViewController+MGLMapViewDelegate.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import UIKit
import Mapbox


extension MapViewController: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        fetchPins()
        
        guard let userLocation = mapView.userLocation?.location?.coordinate else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.mapView.setCenter(userLocation, zoomLevel: 12, animated: true)
        }
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        print("unable to load map: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "deleteButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        return button
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        showDeleteAlert(for: annotation)
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard isFirstLocationUpdate else { return }
        
        isFirstLocationUpdate = false
        
        guard let location = userLocation?.coordinate,
            location.latitude != mapView.centerCoordinate.latitude
                && location.longitude != mapView.centerCoordinate.longitude else {
                    return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mapView.setCenter(location, zoomLevel: 12, animated: true)
        }
    }
    
    private func showDeleteAlert(for annotation: MGLAnnotation) {
        let alertController = UIAlertController(title: "Are You Sure?",
                                                message: "Do you want to delete this pin?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.mapView.removeAnnotation(annotation)
            
            let codableCoordinate = Coordinate(latitude: annotation.coordinate.latitude,
                                               longitude: annotation.coordinate.longitude)
            let tempLocation = MapLocation(coordinate: codableCoordinate, elevation: 0)
            self.deleteOfflineRegion(for: tempLocation)
            self.delete(tempLocation)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
