//
//  Result.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
