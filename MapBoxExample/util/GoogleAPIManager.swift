//
//  GoogleAPIManager.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation

/// If the API key must go in the client... <need your own>
class GoogleAPIManager {
    
    private static let part0 = "r"
    private static let part1 = "e"
    private static let part2 = "d"
    private static let part3 = "a"
    private static let part4 = "c"
    private static let part5 = "t"
    private static let part6 = "e"
    private static let part7 = "d"
    private static let part8 = ":"
    private static let part9 = "("
    
    static func apiKey() -> String {
        return part3 + part8 + part0 + part7 + part9 + part7 + part6 + part1 + part5 + part7 + part4 + part2
    }
}
