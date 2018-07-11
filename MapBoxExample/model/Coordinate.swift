//
//  Coordinate.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation
import CoreLocation


struct Coordinate: Encodable, Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    var clCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
