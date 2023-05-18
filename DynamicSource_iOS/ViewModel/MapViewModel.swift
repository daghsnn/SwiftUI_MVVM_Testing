//
//  MapViewModel.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//

import SwiftUI
import MapKit
import CoreLocation



protocol MapViewModelProtocol : AnyObject {
    func getData(path:String)
    func configureMap(model:ResponseModel)
    func configureCoordinates(_ longitude:String, _ latitude:String)
}

class MapViewModel: ObservableObject, MapViewModelProtocol {
    
    @Published var coordinate = MKCoordinateRegion.init()
    @Published var landMarks: [LandmarkModel] = []
    @Published var isLoading = true

    private let bundlePath = "epwa_example_incomplete"
    
    init() {
        getData(path:bundlePath)
        isLoading = false
    }
    
    func getData(path:String) {
        guard let fileURL = Bundle.main.url(forResource: bundlePath, withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            let model = try JSONDecoder().decode(ResponseModel.self, from: data)
            
            configureMap(model: model)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureMap(model:ResponseModel) {
        if let longitude = model.epwa?.longitude, let latitute = model.epwa?.latitude {
            configureCoordinates(longitude,latitute)
        }
    }
    
    func configureCoordinates(_ longitude:String, _ latitude:String) {
        let longitudeString = longitude.suffix(1)
        let latitudeString = latitude.suffix(1)
        
        let longitudeTrimmedString = longitude.dropLast()
        let latitudeTrimmedString = latitude.dropLast()

        let longitudeLeadingZeros = longitudeTrimmedString.trimmingCharacters(in: ["0"])
        let latitudeLeadingZeros = latitudeTrimmedString.trimmingCharacters(in: ["0"])

        if let longitudeValue = Float(longitudeLeadingZeros), let latituteValue = Float(latitudeLeadingZeros) {
            var longitude = longitudeValue / 10000
            var latitude = latituteValue / 10000

            self.coordinate = .init(center: CLLocationCoordinate2DMake(Double(latitude), Double(longitude)), latitudinalMeters: 100, longitudinalMeters: 100)
            self.landMarks = [LandmarkModel(coordinate: coordinate.center, name: "WARSAW CHOPIN", title: "EPWA")]
        } else {
            // Geçerli bir değer bulunamadığında hata işleme yapabilirsiniz
            print("Geçerli bir latitude değeri bulunamadı.")
        }

    }
}
