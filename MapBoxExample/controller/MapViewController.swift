//
//  MapViewController.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/11/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import UIKit
import Mapbox


// NOTE: IBDesignable issue in Main.storyboard is a Mapbox issue:
//       see: https://github.com/mapbox/mapbox-navigation-ios/issues/210

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    var isFirstLocationUpdate = true
    
    private lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(handleLongPress(recognizer:)))
        recognizer.minimumPressDuration = 1.0
        recognizer.delegate = self
        return recognizer
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        
        let tapLocation = recognizer.location(in: mapView)
        let coordinate = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        addPoint(for: coordinate)
    }
    
    func addAnnotation(for mapLocation: MapLocation) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = mapLocation.coordinate.clCoordinate
        annotation.title = self.titleString(from: mapLocation.coordinate) ?? ""
        annotation.subtitle = self.elevationString(from: mapLocation.elevation) ?? ""
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func addPoint(for coordinate: CLLocationCoordinate2D) {
        ElevationManager.shared.elevation(for: coordinate) { result in
            switch result {
            case .success(let mapLocation):
                self.save(mapLocation)
                self.saveOfflineRegion(for: mapLocation)
                self.addAnnotation(for: mapLocation)
                
            case .failure(let error):
                self.showElevationAlert(for: error)
            }
        }
    }
    
    private func showElevationAlert(for error: ElevationRequestError) {
        print("elevation API error: \(error.developerDescription)")
        
        let alertController = UIAlertController(title: "An Error Occurred",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func titleString(from coordinate: Coordinate) -> String? {
        let lat = NSNumber(value: coordinate.latitude)
        let long = NSNumber(value: coordinate.longitude)
        
        guard let latString = Formatters.latLongFormatter.string(from: lat),
            let longString = Formatters.latLongFormatter.string(from: long) else {
                return nil
        }
        
        return "\(latString), \(longString)"
    }
    
    private func elevationString(from elevation: Double) -> String? {
        let elevation = NSNumber(value: elevation)
        guard let string = Formatters.elevationFormatter.string(from: elevation) else {
            return nil
        }
        
        return "MSL: \(string)m"
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // disabling interference with MapBox's built in TapGestureRecognizer
        return gestureRecognizer === longPressRecognizer
            && otherGestureRecognizer is UITapGestureRecognizer
    }
}
