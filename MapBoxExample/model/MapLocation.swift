//
//  MapLocation.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation


struct MapLocation {
    let coordinate: Coordinate
    let elevation: Double
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coordinate"
    }
}

extension MapLocation: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate, forKey: .coordinate)
    }
}

extension MapLocation: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try values.decode(Coordinate.self, forKey: .coordinate)
        elevation = 0
    }
}
