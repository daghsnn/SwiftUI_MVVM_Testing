//
//  MapViewTest.swift
//  DynamicSource_iOSTests
//
//  Created by Hasan Dag on 20.05.2023.
//


import XCTest

@testable import DynamicSource_iOS

class MapViewSPY : MapViewProtocol {

    var invokedViewModelSetter = false
    var invokedViewModelSetterCount = 0
    var invokedViewModel: MapViewModel?
    var invokedViewModelList = [MapViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: MapViewModel!

    var viewModel: MapViewModel {
        set {
            invokedViewModelSetter = true
            invokedViewModelSetterCount += 1
            invokedViewModel = newValue
            invokedViewModelList.append(newValue)
        }
        get {
            invokedViewModelGetter = true
            invokedViewModelGetterCount += 1
            return stubbedViewModel
        }
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (message: String, Void)?
    var invokedShowAlertParametersList = [(message: String, Void)]()

    func showAlert(withMessage message: String) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (message, ())
        invokedShowAlertParametersList.append((message, ()))
    }
}

final class MapViewTest: XCTestCase {
    var sut : MapViewSPY!
    var viewModel : MapViewModel!
    
    override func setUpWithError() throws {
        sut = MapViewSPY()
        viewModel = MapViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
    }

    func test_mapView_haveViewModel() throws {
        sut.viewModel = viewModel
        XCTAssertEqual(sut.invokedViewModelSetterCount, 1)
    }
    
    func test_mapView_showedError() throws {
        sut.viewModel = viewModel
        sut.showAlert(withMessage: "test messaage")
        XCTAssertEqual(sut.invokedShowAlertParameters?.message, "test messaage")
    }

}
