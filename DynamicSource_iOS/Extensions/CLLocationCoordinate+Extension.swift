//
//  CLLocationCoordinate+Extension.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 20.05.2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func coordinateWithDegree(degree: CLLocationDirection, distance: CLLocationDistance) -> CLLocationCoordinate2D {
        let distRadiansLat = distance / (6372797.6 * Double.pi / 180.0)
        let distRadiansLong = distance / (cos(latitude / 180.0 * Double.pi) * 6372797.6 * Double.pi / 180.0)
        
        let lat1 = self.latitude * Double.pi / 180
        let lon1 = self.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(degree))
        let lon2 = lon1 + atan2(sin(degree) * sin(distRadiansLong) * cos(lat1), cos(distRadiansLong) - sin(lat1) * sin(lat2))
        
        let newLatitude = lat2 * 180 / Double.pi
        let newLongitude = lon2 * 180 / Double.pi
        
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
}
