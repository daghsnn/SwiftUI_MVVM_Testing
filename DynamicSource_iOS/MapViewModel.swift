//
//  MapViewModel.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct LandmarkModel: Identifiable {
    let id = UUID()
    let coordinate : CLLocationCoordinate2D
    
    var name : String
    var title : String
}

protocol MapViewModelProtocol : AnyObject {
    func getData()
    func configureCoordinates(_ longitude:String?, _ latitude:String?)
}

class MapViewModel: ObservableObject {
    
    @Published var coordinate = MKCoordinateRegion.init()
    @Published var landMarks: [LandmarkModel] = []

    init() {
        getData()
    }
    
    private func getData() {
        guard let fileURL = Bundle.main.url(forResource: "epwa_example_incomplete", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            let model = try JSONDecoder().decode(ResponseModel.self, from: data)
            let longitude = model.epwa?.longitude
            let latitute = model.epwa?.latitude
            
            configureCoordinates(longitude,latitute)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configureCoordinates(_ longitude:String?, _ latitude:String?) {
        guard let longitude, let latitude else {return}
        let longitudeString = longitude.suffix(1)
        let latituteString = latitude.suffix(1)
        
        
//        let shiftedString = string.dropFirst(3)
//        let formattedString = shiftedString.prefix(2) + "." + shiftedString.suffix(shiftedString.count - 2)

        
        let longitudeTrimmedString = longitude.dropLast()
        let latituteTrimmedString = latitude.dropLast()

        let longitudeLeadingZeros = longitudeTrimmedString.trimmingCharacters(in: ["0"])
        let latituteLeadingZeros = latituteTrimmedString.trimmingCharacters(in: ["0"])

        if let longitudeValue = Float(longitudeLeadingZeros), let latituteValue = Float(latituteLeadingZeros) {
            var longitude = longitudeValue / 10000
            var latitude = latituteValue / 10000

            if longitudeString == "S" {
                longitude *= -1
            }
            
            if latituteString == "S" {
                latitude *= -1
            }
            self.coordinate = .init(center: CLLocationCoordinate2DMake(Double(latitude), Double(longitude)), latitudinalMeters: 100, longitudinalMeters: 100)
            self.landMarks = [LandmarkModel(coordinate: coordinate.center, name: "WARSAW CHOPIN", title: "EPWA")]
        } else {
            // Geçerli bir değer bulunamadığında hata işleme yapabilirsiniz
            print("Geçerli bir latitude değeri bulunamadı.")
        }

    }
}
