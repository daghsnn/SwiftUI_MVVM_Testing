//
//  MapView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import SwiftUI
import CoreLocation
import MapKit

protocol MapViewProtocol {
    var viewModel: MapViewModel { get set }
    func showAlert(withMessage message: String)
}

struct MapView: View, MapViewProtocol {
    
    @ObservedObject var viewModel: MapViewModel = MapViewModel()
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @State private var width: CGFloat = 100
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
                                if annotation.name != "obstacle" {
                                    AnnotationView(annotation: annotation)
                                        .overlay {
                                            Rectangle()
                                                .fill(Color.red.opacity(0.2))
                                                .frame(width: width,height: height)
                                                .rotationEffect(Angle(degrees: Double(110)))
                                        }
                                } else {
                                    AnnotationView(annotation: annotation)
                                }

                            }
                        }.frame(width: UIScreen.WIDTH, height: UIScreen.HEIGHT, alignment: .center)
                            .onChange(of: viewModel.coordinate.span.longitudeDelta) { _ in
                                calculateWidthInPoints()
                            }
                        
                    }
                }
            }.navigationBarTitle(Text(localizableKey: "flight_name"),displayMode: .automatic)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(localizableKey: "error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text(localizableKey: "okey")) {
                            showAlert = false
                        })
                }
        }.onAppear{
            self.viewModel.view = self
            self.viewModel.getData()
        }
    }
    
    func calculateWidthInPoints() {
        let metersPerDegreeLatitude = viewModel.coordinate.span.latitudeDelta * 111_111 // Approximate meters per degree latitude
        let metersPerDegreeLongitude = viewModel.coordinate.span.longitudeDelta * 111_320 // Approximate meters per degree longitude
        let widthInDegrees = viewModel.getWidth() / metersPerDegreeLongitude
        let heightInDegrees = viewModel.getWidth() / metersPerDegreeLatitude
        
        let pointsPerDegreeLongitude = UIScreen.WIDTH / CGFloat(viewModel.coordinate.span.longitudeDelta)
        let pointsPerDegreeLatitude = 300 / CGFloat(viewModel.coordinate.span.latitudeDelta)
        
        self.width = widthInDegrees * pointsPerDegreeLongitude / 100
        self.height = heightInDegrees * pointsPerDegreeLatitude / 100
    }
}

extension MapView {
    func showAlert(withMessage message: String) {
        viewModel.isLoading = false
        errorMessage = message
        showAlert = true
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
