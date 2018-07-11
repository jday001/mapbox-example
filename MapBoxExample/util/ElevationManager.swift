//
//  ElevationManager.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


enum ElevationRequestError: Error {
    case invalid
    case json
    case overLimit
    case denied
    case unknown
    
    init(status: String) {
        switch status {
        case "INVALID_REQUEST":  self = .invalid
        case "OVER_QUERY_LIMIT": self = .overLimit
        case "REQUEST_DENIED":   self = .denied
        default:                 self = .unknown
        }
    }
    
    var localizedDescription: String {
        return "Unable to retrieve location data at this time. Please check your internet connection and try again."
    }
    
    var developerDescription: String {
        switch self {
        case .invalid:   return "The API request was malformed."
        case .json:      return "Invalid JSON response."
        case .overLimit: return "The requestor has exceeded quota."
        case .denied:    return "The API did not complete the request."
        case .unknown:   return "Unknown error."
        }
    }
}



class ElevationManager {
    
    static let shared = ElevationManager()
    
    typealias ElevationResult = Result<MapLocation, ElevationRequestError>
    typealias ElevationCompletion = (_ result: ElevationResult) -> Void
    
    
    func elevation(for coordinate: CLLocationCoordinate2D, completion: @escaping ElevationCompletion) {
        let urlString = "https://maps.googleapis.com/maps/api/elevation/json?locations=\(coordinate.latitude),\(coordinate.longitude)&key=\(GoogleAPIManager.apiKey())"
        
        Alamofire.request(urlString).responseJSON { response in
            guard let json = response.result.value as? [String: AnyObject],
                let status = json["status"] as? String else {
                    completion(.failure(.json))
                    return
            }
            
            guard status == "OK" else {
                completion(.failure(ElevationRequestError(status: status)))
                return
            }
            
            guard let results = json["results"] as? [[String: AnyObject]],
                let result = results.first,
                let elevation = result["elevation"] as? Double else {
                    completion(.failure(.json))
                    return
            }
            
            let codableCoordinate = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
            completion(.success(MapLocation(coordinate: codableCoordinate, elevation: elevation)))
        }
    }
}
