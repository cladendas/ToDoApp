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
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
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
    
    //генеррируется token при успешной авторизации
    //token -> Data -> comletionHandler -> DataTask -> urlSession
    func testSuccesfulLoginCreatesToken() {
        //заготовленный ответ
        let jsonDataStub = "{\"token\": \"token\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        //ожидание
        let tokenExpectation = expectation(description: "Token expectation")
        
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "token")
        }
    }
    
    //правильный формат JSON
    func testLoginInvalidJSONReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        //ожидание
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    //вместо JSON или другого формата приходит nil, то выдаётся ошибка
    func testLoginWhenDataIsNilReturnsError() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        //ожидание
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    //сервер возвращает ошибку
    func testLoginWhenResponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 2) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        
        override func resume() {
            //ассинхронное выполнение относительно всего остального кода
            DispatchQueue.main.async {
                self.completionHandler? (
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
