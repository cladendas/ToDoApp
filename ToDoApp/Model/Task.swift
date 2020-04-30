//
//  Task.swift
//  ToDoApp
//
//  Created by cladendas on 30.04.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import Foundation

struct Task {
    var title: String
    var description: String?
    private(set) var date: Date?
    
    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
        self.date = Date()
    }
    
}
