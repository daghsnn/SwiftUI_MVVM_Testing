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
    var view : MapViewProtocol? {get set}
    func getData(path:String)
    func configureCoordinates(_ longitude:String, _ latitude:String) -> MKCoordinateRegion?
    func configureLandmarks(_ region: CLLocationCoordinate2D, model:ResponseModel) -> [LandmarkModel]
    func generateSpan(_ width:Int) -> MKCoordinateSpan
    func getWidth() -> Double
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
    
    func configureLandmarks(_ region: CLLocationCoordinate2D, model:ResponseModel) -> [LandmarkModel] {
        var landMarks : [LandmarkModel] = []
        if let name = model.epwa?.name?.uppercased() {
            landMarks.append(LandmarkModel(coordinate: region, name: name))
        }
        
        let slope = Double(model.epwa?.rwy?.the11?.slope ?? "0") ?? 0
        
        if let obstacles = model.epwa?.rwy?.the11?.obstacles {
            for obstacle in obstacles {
                if let distance = Double(obstacle.distance ?? "0") {
                    // I divided by 1000 because JSON's units not clear If I dont divide obstacles are so away from the poland and that Case Study about a airport rwy 11 so I notice the obstacles might be near on the RWY 11
                    let center = createCoordinate(at: region, withDistance: CLLocationDistance(distance / 1000), direction: CLLocationDirection(slope))
                    landMarks.append(LandmarkModel(coordinate: center, name: "obstacle"))
                }
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
        let isLatitudeNegative = latitude.hasSuffix("S")
        let isLongitudeNegative = longitude.hasSuffix("W")

        let longitudeTrimmedString = longitude.dropLast()
        let latitudeTrimmedString = latitude.dropLast()

        let longitudeLeadingZeros = longitudeTrimmedString.trimmingCharacters(in: ["0"])
        let latitudeLeadingZeros = latitudeTrimmedString.trimmingCharacters(in: ["0"])

        if let longitudeValue = Float(longitudeLeadingZeros), let latituteValue = Float(latitudeLeadingZeros) {
            let finalLatitude = isLatitudeNegative ? -latituteValue : latituteValue
            let finalLongitude = isLongitudeNegative ? -longitudeValue : longitudeValue

            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(finalLatitude / 10000), longitude: CLLocationDegrees(finalLongitude / 10000))
            return MKCoordinateRegion(center: center, span: span)
        } else {
            view?.showAlert(withMessage: LocalizeTexts.makeLocalize(.coordinatsWrong))
            return nil
        }

    }
}
