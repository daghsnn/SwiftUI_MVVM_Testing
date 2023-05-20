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
    
    private var width : Double = 0
    
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
                    self.configureUI(span: span, region: region, landMarks: self.configureLandmarks(region?.center ?? .init(), model: model))
                }
            }
        }
    }
    
    private func configureUI(span:MKCoordinateSpan?,region:MKCoordinateRegion?, landMarks:[LandmarkModel]) {
        DispatchQueue.main.async {
            self.isLoading = false
            guard let span, let region else {return}
            self.span = span
            self.coordinate = .init(center: region.center, span: span)
            self.landMarks = landMarks
        }
    }
    
    private func configureLandmarks(_ region: CLLocationCoordinate2D, model:ResponseModel) -> [LandmarkModel] {
        var landMarks : [LandmarkModel] = []
        if let name = model.epwa?.name?.uppercased() {
            landMarks.append(LandmarkModel(coordinate: region, name: name))
        }
        
        if let obstacles = model.epwa?.rwy?.the11?.obstacles {
            for obstacle in obstacles {
                let center = createCoordinate(at: region, withDistance: CLLocationDistance(Double(obstacle.distance ?? "0") ?? 0), direction: CLLocationDirection(-0.21))
                landMarks.append(LandmarkModel(coordinate: center, name: "obstacle"))
            }
        }
        
        return landMarks
    }
    
    func createCoordinate(at sourceCoordinate: CLLocationCoordinate2D, withDistance distance: CLLocationDistance, direction: CLLocationDirection) -> CLLocationCoordinate2D {
        
        let sourceLocation = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        let destinationLocation = sourceLocation.coordinate.coordinateWithDegree(degree: direction, distance: distance)
        
        return destinationLocation
    }

    
    func generateSpan(_ width:Int) -> MKCoordinateSpan {
        self.width = Double(width)
        return MKCoordinateSpan(latitudeDelta: self.width / 10000, longitudeDelta: self.width / 10000)
    }
    
    func getWidth() -> Double {
        self.width
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
