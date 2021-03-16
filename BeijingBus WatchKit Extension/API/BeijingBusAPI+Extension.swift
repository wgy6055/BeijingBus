//
//  BeijingBusAPI+Extension.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/12.
//

import Foundation
import CoreLocation

extension Coordinate {
    public var CLCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
