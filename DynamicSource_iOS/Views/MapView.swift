//
//  MapView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @ObservedObject var viewModel = MapViewModel()
    @State private var selectedAnnotate : LandmarkModel?

    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $viewModel.coordinate,
                    interactionModes: .all,
                    annotationItems: viewModel.landMarks) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        Text(annotation.name).onTapGesture {
                            // Modeli buraya annotationItems olarak verdikten sonra click işlemleri
                            self.selectedAnnotate = annotation
                            print("tiklandi")
                        }
                        Image(systemName: "airplane.departure")
                            .resizable()
                            .frame(width: UIScreen.WIDTH * 0.1,height: UIScreen.HEIGHT * 0.1)
                            .foregroundColor(.yellow)
                    }
                }.frame(width: UIScreen.WIDTH, height: UIScreen.HEIGHT * 0.8, alignment: .bottom)
            }.navigationBarTitle(Text(localizableKey: "flight_name"),displayMode: .automatic)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
