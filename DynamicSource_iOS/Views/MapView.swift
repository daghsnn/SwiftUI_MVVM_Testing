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
    @State private var width: CGFloat = 100 // State to update with Binding
    @State private var height: CGFloat = 100
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView(LocalizedStringKey("loading"))
                } else {
                    ZStack {
                        Map(coordinateRegion: $viewModel.coordinate,
                            interactionModes: .all,
                            annotationItems: viewModel.landMarks) { annotation in
                            
                            MapAnnotation(coordinate: annotation.coordinate) {
                                AnnotationView(annotation: annotation)
                                    .overlay {
                                        Rectangle()
                                            .fill(Color.red.opacity(0.2))
                                            .frame(width: width,height: height)
                                            .rotationEffect(Angle(degrees: Double(110)))
                                    }
                            }
                        }.frame(width: UIScreen.WIDTH, height: UIScreen.HEIGHT, alignment: .center)
                            .onChange(of: viewModel.coordinate.span.longitudeDelta) { _ in
                                calculateWidthInPoints()
                            }
                        
                    }
                }
            }.navigationBarTitle(Text(localizableKey: "flight_name"),displayMode: .automatic)
            
        }
    }
    
    func calculateWidthInPoints() {
        let metersPerDegreeLatitude = viewModel.coordinate.span.latitudeDelta * 111_111 // Approximate meters per degree latitude
        let metersPerDegreeLongitude = viewModel.coordinate.span.longitudeDelta * 111_320 // Approximate meters per degree longitude
        let widthInDegrees = 360 / metersPerDegreeLongitude
        let heightInDegrees = 160 / metersPerDegreeLatitude
        
        let pointsPerDegreeLongitude = UIScreen.WIDTH / CGFloat(viewModel.coordinate.span.longitudeDelta)
        let pointsPerDegreeLatitude = 300 / CGFloat(viewModel.coordinate.span.latitudeDelta)
        
        self.width = widthInDegrees * pointsPerDegreeLongitude / 100
        self.height = heightInDegrees * pointsPerDegreeLatitude / 100
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
