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
            if annotation.name != "obstacles" {
                VStack(spacing: 8) {
                    Text(annotation.name).font(.title)
                    
                
//                ZStack(alignment: .center) {
//                    Rectangle()
//                        .fill(Color.red)
//                        .frame(width: 164, height: 361)
//                    VStack(spacing: 8) {
//                        Text(annotation.name)
//                        Image(systemName: "airplane.departure")
//                            .resizable()
//                            .frame(width: UIScreen.WIDTH * 0.1,height: UIScreen.HEIGHT * 0.1)
//                            .foregroundColor(.yellow)
//                    }
                }
            } else {
                // nesneler pist engeller
                Image(systemName: "airport.extreme.tower")
                    .resizable()
                    .frame(width: UIScreen.WIDTH * 0.1,height: UIScreen.HEIGHT * 0.1)
                    .foregroundColor(.yellow)
                Rectangle()
                    .fill(Color.red).frame(width: 0.000164 * 1000,height: 361)
            }
        }
       
    }
}
