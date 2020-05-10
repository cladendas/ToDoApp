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
        
        sut.save()
        
        let task = sut.taskManager.task(at: 0)
        let coordinate = CLLocationCoordinate2D(latitude: 40.7130125, longitude: -74.0071296)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        XCTAssertEqual(task, generatedTask)
    }
}
