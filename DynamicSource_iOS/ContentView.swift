//
//  ContentView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//

import SwiftUI
import CoreLocation
import MapKit
import UIKit

struct ContentView: View {
    
    @ObservedObject var viewModel = MapViewModel()
    @State private var selectedAnnotate : LandmarkModel?
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
                        Image(systemName: "airplane.circle.fill")
                            .foregroundColor(.yellow)
                            .frame(width: UIScreen.WIDTH * 0.01,height: UIScreen.HEIGHT * 0.005)
                    }
                
                }.padding()
                    .navigationBarTitle("Flight Scene",displayMode: .automatic)
            }
        }
    }
}

extension ContentView : MapViewClickDelegate {
    func userClicked(coordiante: CLLocationCoordinate2D) {
        //
    }
    
    
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("İkinci Ekran")
        }
        .navigationBarTitle("İkinci Ekran")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
