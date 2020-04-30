//
//  LocationTest.swift
//  ToDoAppTests
//
//  Created by cladendas on 01.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class LocationTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitSetsName() {
        let locaton = Location(name: "Foo")
        XCTAssertEqual(locaton.name, "Foo")
    
    }
    
    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }

}
