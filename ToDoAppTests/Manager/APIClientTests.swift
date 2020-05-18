//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by cladendas on 18.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {
    
    let mockURLSession = MockURLSession()
    let sut = APIClient()
    
    override func setUp() {
        sut.urlSession = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in}
        //в url адресах некоторые символы имеют другое значение: % - это не процент и прочее
        //https://en.wikipedia.org/wiki/Percent-encoding
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    //при логировании обращение к серверу использует правильный хост
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    //проверка path адреса
    func testLoginCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    //по хосту передаются правильные параметры
    func testLoginUsesExpectedQueryParameters() {
        userLogin()
        
        //name и password могут идти в разной последовательности, поэтому надо проверить именно их наличие в query
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}
