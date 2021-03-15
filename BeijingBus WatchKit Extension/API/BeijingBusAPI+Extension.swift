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

extension LineDetail {
    var parsedLineCoordinates: [CLLocationCoordinate2D] {
        let pairs = self.coords.split(separator: ",").reduce(([], nil)) { (sum, new) -> ([(Substring, Substring)], Substring?) in
            if let last = sum.1 {
                return (sum.0 + [(last,new)] , nil)
            } else {
                return (sum.0, new)
            }
        }.0
        return pairs.compactMap {
            if let lat = Double($0.1),
                let long = Double($0.0) {
                return CLLocationCoordinate2D(latitude: lat, longitude: long)
            } else {
                return nil
            }
        }
    }
}
