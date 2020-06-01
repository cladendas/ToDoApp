//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by cladendas on 30.04.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //при загрузке приложения, главный экран это TaskListViewController и он встроен в NavigationController
    func testInitialViewControllerIsTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers.first as! TaskListViewController
        
        XCTAssertTrue(rootViewController is TaskListViewController)
    }
    
    //при нажатии на кнопку addButton переходит на экран NewTaskViewController
    
}
