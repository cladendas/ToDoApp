//
//  String+extensions.swift
//  ToDoApp
//
//  Created by cladendas on 18.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import Foundation

extension String {
    var percentEncoded: String {
        //расшифровываются все символы, кроме указанных
        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\}{,./?><").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        return encodedString
    }
}
