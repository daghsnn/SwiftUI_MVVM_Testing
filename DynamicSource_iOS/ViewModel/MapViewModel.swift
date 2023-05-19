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
    func configureCoordinates(_ longitude:String, _ latitude:String) -> MKCoordinateRegion?
}

final class MapViewModel: ObservableObject, MapViewModelProtocol {
    
    var view : MapViewProtocol?

    @Published var coordinate = MKCoordinateRegion.init()
    @Published var landMarks: [LandmarkModel] = []
    @Published var span: MKCoordinateSpan = .init()

    @Published var isLoading = true
    
    let queue = DispatchQueue(label: "concurreny", qos: .userInitiated, attributes: .concurrent)
    
    func getData(path:String = "epwa_example_incomplete") {
        guard let fileURL = Bundle.main.url(forResource: path, withExtension: "json") else {
            view?.showAlert(withMessage: LocalizeTexts.makeLocalize(.pathNotFound))
            return }
        do {
            let data = try Data(contentsOf: fileURL)
            let model = try JSONDecoder().decode(ResponseModel.self, from: data)
            
            configureMap(model: model)
            
        } catch {
            view?.showAlert(withMessage: error.localizedDescription)
        }
    }
    
    private func configureMap(model:ResponseModel) {
        if let longitudeString = model.epwa?.longitude, let latitudeString = model.epwa?.latitude {
            let group = DispatchGroup()
            
            queue.async {
                group.enter()
                let span = self.generateSpan(model.epwa?.rwy?.the11?.width ?? 0)
                group.leave()
                
                group.enter()
                let region = self.configureCoordinates(longitudeString, latitudeString)
                group.leave()
                
                group.notify(queue: self.queue) {
                    self.configureUI(span: span, region: region, modelName: model.epwa?.name)
                }
            }
        }
    }
    private func configureUI(span:MKCoordinateSpan?,region:MKCoordinateRegion?, modelName:String?) {
        DispatchQueue.main.async {
            self.isLoading = false
            guard let span, let region else {return}
            self.span = span
            self.coordinate = .init(center: region.center, span: span)
            self.landMarks = [LandmarkModel(coordinate: self.coordinate.center, name: modelName?.uppercased() ?? "")]
        }
    }
    
    func generateSpan(_ width:Int) -> MKCoordinateSpan {
        let width = Double(width)
        return MKCoordinateSpan(latitudeDelta: width / 10000, longitudeDelta: width / 10000)
    }
    
    func configureCoordinates(_ longitude:String, _ latitude:String) -> MKCoordinateRegion? {
        let longitudeTrimmedString = longitude.dropLast()
        let latitudeTrimmedString = latitude.dropLast()

        let longitudeLeadingZeros = longitudeTrimmedString.trimmingCharacters(in: ["0"])
        let latitudeLeadingZeros = latitudeTrimmedString.trimmingCharacters(in: ["0"])

        if let longitudeValue = Float(longitudeLeadingZeros), let latituteValue = Float(latitudeLeadingZeros) {
            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(latituteValue / 10000), longitude: CLLocationDegrees(longitudeValue / 10000))
            return MKCoordinateRegion(center: center, span: span)
        } else {
            view?.showAlert(withMessage: LocalizeTexts.makeLocalize(.coordinatsWrong))
            return nil
        }

    }
}
