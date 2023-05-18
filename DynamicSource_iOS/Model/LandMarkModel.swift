//
//  LandMarkModel.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import SwiftUI

struct LandmarkModel: Identifiable {
    let id = UUID()
    let coordinate : CLLocationCoordinate2D
    var name : String
    var title : String
}
