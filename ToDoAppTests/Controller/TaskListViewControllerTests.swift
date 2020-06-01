//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by cladendas on 02.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //TaskListViewController загружается, TableView присутствует на TaskListViewController
    func testWhenViewIsLoadedTableViewNotNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    //при загрузке контроллера делегат для TableView установлен
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    //делеагатом и датасорсом для TableView является DataProvider
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSoursce() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider
        )
    }
    
    //есть кнопка addButton и таргет у этой кнопки сам тестируемый класс
    func testTaskListVCHasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    //при нажатии addButton появляется NewtaskViewController
    func testAddNewtaskPresentsNewTaskViewController() {
        //при срабатывании этого метода, не отображается какой-то дополнительный ViewController
        XCTAssertNil(sut.presentedViewController)
        
        guard
            let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action else {
                XCTFail()
                return
        }
        
        //не получится создать контроллер с контроллера, который уже не на экране (в реальном приложение будет работать, но в тесте - нет)
        //sut добавляется в качестве root контроллера у window
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        //action выполняется в главном потоке, action выполняет newTaskButton, ждём пока окончитя - да
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is NewTaskViewController)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
}
