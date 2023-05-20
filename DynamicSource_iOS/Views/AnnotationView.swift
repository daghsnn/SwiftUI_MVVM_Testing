//
//  AnnotationView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 19.05.2023.
//

import SwiftUI

struct AnnotationView: View {
    
    var annotation : LandmarkModel
    
    init(annotation: LandmarkModel) {
        self.annotation = annotation
    }
    
    var body: some View {
        VStack {
            if annotation.name != "obstacle" {
                VStack(spacing: 8) {
                    Text(annotation.name).font(.title)
                }
            } else {
                Text(annotation.name).font(.title)
                Image(systemName: "airport.extreme.tower")
                    .resizable()
                    .frame(width: UIScreen.WIDTH * 0.1,height: UIScreen.HEIGHT * 0.1)
                    .foregroundColor(.yellow)
            }
        }
       
    }
}
