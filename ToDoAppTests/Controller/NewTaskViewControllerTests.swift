//
//  NewTaskViewController.swift
//  ToDoAppTests
//
//  Created by cladendas on 10.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemarck!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //наличие titleTextField на NewTaskViewController
    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    //наличие locationTextField на NewTaskViewController
    func testHasLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasAdressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasACancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    //проверка при сохранении нового таска используется GeoCoder для возможности отображения на карте введённого адреса
    func testSaveUsesGeocoderToConvertCoordinateFromAddres() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        let date = df.date(from: "09.05.2020")
        
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "09.05.2020"
        sut.addressTextField.text = "New York"
        sut.descriptionTextField.text = "Baz"
        sut.taskManager = TaskManager()
        
        let mockGeocoder = MockClGeocoder()
        sut.geocoder = mockGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.7130125, longitude: -74.0071296)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        placemark = MockCLPlacemarck()
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }
    
    //save привязан к кнопке
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
    //по адресу получаем координаты из интернера
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer") //ожидание
        let addressString = "New York"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard
                let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude else {
                    XCTFail()
                    return
            }
            XCTAssertEqual(latitude, 40.7130125)
            XCTAssertEqual(longitude, -74.0071296)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //после нажатия save экран создания новой задачи должен уйти
    func testSaveDismissesNewTaskViewController() {
        let mockNewTaskViewController = MockNewTaskViewController()
        mockNewTaskViewController.titleTextField = UITextField()
        mockNewTaskViewController.titleTextField.text = "Foo"
        mockNewTaskViewController.descriptionTextField = UITextField()
        mockNewTaskViewController.descriptionTextField.text = "Bar"
        mockNewTaskViewController.locationTextField = UITextField()
        mockNewTaskViewController.locationTextField.text = "Baz"
        mockNewTaskViewController.addressTextField = UITextField()
        mockNewTaskViewController.addressTextField.text = "New York"
        mockNewTaskViewController.dateTextField = UITextField()
        mockNewTaskViewController.dateTextField.text = "09.05.2020"
        
        //when
        mockNewTaskViewController.save()
        
        //then
        XCTAssertTrue(mockNewTaskViewController.isDismidded)
    }
}

extension NewTaskViewControllerTests {
    //нужен, чтобы получать координаты без подключения к инету
    class MockClGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemarck: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}

extension NewTaskViewControllerTests {
    class MockNewTaskViewController: NewTaskViewController {
        var isDismidded = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismidded = true
        }
    }
}
