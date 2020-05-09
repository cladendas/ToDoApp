//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by cladendas on 08.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //на DetailViewController есть ярлык titleLable и он присутствует на вью
    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    //на DetailViewController есть ярлык descriptionLabel и он присутствует на вью
    func testHasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }

    //на DetailViewController есть ярлык dateLabel и он присутствует на вью
    func testHasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    //на DetailViewController есть ярлык locationLabel и он присутствует на вью
    func testHasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    //на DetailViewController есть mapKit
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func setupTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7143528, longitude: -74.0059731)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1589053174)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        sut.task = task
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    //на DetailViewController есть правильный titleLabel конкретного Task
    func testSettingTaskSetsTitlelabel() {
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    //на DetailViewController есть правильный descriptionLabel конкретного Task
    func testSettingTaskSetsDescriptionlabel() {
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    //на DetailViewController есть правильный locationLabel конкретного Task
    func testSettingTaskSetsLocationlabel() {
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    //на DetailViewController есть правильный dateLabel конкретного Task
    func testSettingTaskSetsDatelabel() {
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.dateLabel.text, "09.05.2020")
    }
    
    //на DetailViewController есть mapView конкретного Task
    func testSettingTaskSetsMapView() {
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 40.7143528, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, -74.0059731, accuracy: 0.001)
    }
}
