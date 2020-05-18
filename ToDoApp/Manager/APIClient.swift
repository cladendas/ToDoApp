//
//  APIClient.swift
//  ToDoApp
//
//  Created by cladendas on 18.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        
        let allowedCharacters = CharacterSet.urlQueryAllowed //символы, которые не нужно расшифровывать
        
//        URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
//        URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
//        URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
//        URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
//        URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
//        URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
//        https://stackoverflow.com/questions/24551816/swift-encode-url
        
        guard
            let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
                fatalError()
        }
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else {
            fatalError()
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
        }.resume()
    }
}
