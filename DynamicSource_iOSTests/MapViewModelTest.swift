//
//  MapViewModelTest.swift
//  DynamicSource_iOSTests
//
//  Created by Hasan Dag on 20.05.2023.
//

import XCTest
import CoreLocation
import MapKit

@testable import DynamicSource_iOS

final class MapViewModelTest: XCTestCase {
    var sut : MapViewModelSPY!
    var view : MapView!
    
    override func setUpWithError() throws {
        sut = MapViewModelSPY()
        view = MapView()
        sut.view = view
    }

    override func tearDownWithError() throws {
        sut = nil
        view = nil
    }

    func test_viewModel_ViewHaveSetter() throws {
        sut.view = view
        
        XCTAssertTrue(sut.invokedViewSetter)
    }
    
    func test_viewModel_ViewHaveGetter() throws {
        let view = sut.view
        
        XCTAssertTrue(sut.invokedViewGetter)
    }
    
    func test_viewModel_GetDataFail() throws {
        sut.getData(path: "fail")
        XCTAssertFalse(sut.invokedGetData)
    }
    
    func test_viewModel_GetDataSuccess() throws {
        sut.getData(path: "epwa_example_incomplete")
        XCTAssertTrue(sut.invokedGetData)
    }
    
    func test_viewModel_configureCoordinates_invoked() throws {
        sut.configureCoordinates(MockConstants.longitude, MockConstants.latitude)
        XCTAssertTrue(sut.invokedConfigureCoordinates)
    }
    
    func test_viewModel_configureCoordinates_ShouldBeReturnRegion() throws {
        sut.configureCoordinates(MockConstants.longitude, MockConstants.latitude)
        
        XCTAssertEqual(sut.stubbedConfigureCoordinatesResult.center.longitude, CLLocationDegrees(20.5802001953125))
        XCTAssertEqual(sut.stubbedConfigureCoordinatesResult.center.latitude, CLLocationDegrees(52.095699310302734))
    }
    
    func test_viewModel_configureCoordinates_ShouldBeReturnNil() throws {
        sut.configureCoordinates("test fail", "test fail")
        XCTAssertNil(sut.stubbedConfigureCoordinatesResult)
    }
    
    func test_viewModel_generateSpan_ShouldReturnWidth() throws {
        sut.generateSpan(10)
        XCTAssertEqual(sut.invokedGenerateSpanParameters?.width,10)
    }
    
    func test_viewModel_generateSpan_ShouldReturnNotCorrect() throws {
        sut.generateSpan(10)
        XCTAssertNotEqual(sut.invokedGenerateSpanParameters?.width,20)
    }
    
    func test_viewModel_getWidth_ShouldInvoked() throws {
        sut.getWidth()
        XCTAssertTrue(sut.invokedGetWidth)
    }
    
    func test_viewModel_getWidth_ShouldReturnWidth() throws {
        sut.stubbedGetWidthResult = 10
        sut.getWidth()
        XCTAssertEqual(sut.getWidth(), 10)
    }
}

struct MockConstants {
    static var latitude = "052095700N"
    static var longitude = "020580200E"
}

class MapViewModelSPY : MapViewModelProtocol {

    var invokedViewSetter = false
    var invokedViewGetter = false
    var stubbedView: MapViewProtocol!

    var view : MapViewProtocol? {
        set {
            invokedViewSetter = true
        }
        get {
            invokedViewGetter = true
            return stubbedView
        }
    }

    var invokedGetData = false
    var invokedGetDataCount = 0
    var invokedGetDataParameters: (path: String, Void)?
    var invokedGetDataParametersList = [(path: String, Void)]()

    func getData(path:String) {
        guard let fileURL = Bundle.main.url(forResource: path, withExtension: "json") else {
            invokedGetData = false
            return }
        do {
            let data = try Data(contentsOf: fileURL)
            let model = try JSONDecoder().decode(ResponseModel.self, from: data)
            invokedGetData = true
        } catch {
            invokedGetData = false
        }
    }

    var invokedConfigureCoordinates = false
    var stubbedConfigureCoordinatesResult: MKCoordinateRegion!
    
    @discardableResult
    func configureCoordinates(_ longitude:String, _ latitude:String) -> MKCoordinateRegion? {
        invokedConfigureCoordinates = true
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
            stubbedConfigureCoordinatesResult = MKCoordinateRegion(center: center, span: MKCoordinateSpan.init())
        } else {
            stubbedConfigureCoordinatesResult = nil
        }
        return stubbedConfigureCoordinatesResult
    }

    var invokedGenerateSpan = false
    var invokedGenerateSpanParameters: (width: Int, Void)?
    
    @discardableResult
    func generateSpan(_ width:Int) -> MKCoordinateSpan {
        invokedGenerateSpan = true
        invokedGenerateSpanParameters = (width, ())
        return MKCoordinateSpan(latitudeDelta: CLLocationDegrees(width), longitudeDelta: CLLocationDegrees(width))
    }

    var invokedGetWidth = false
    var stubbedGetWidthResult: Double! = 0
    
    @discardableResult
    func getWidth() -> Double {
        invokedGetWidth = true
        return stubbedGetWidthResult
    }
}
