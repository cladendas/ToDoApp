//
//  TaskCell.swift
//  ToDoApp
//
//  Created by cladendas on 02.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    func configure(withTask task: Task) {
        self.titleLabel.text = task.title
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        if let date = task.date {
            let dateString = df.string(from: date)
            dateLabel.text = dateString
        }
        
        self.locationLabel.text = task.location?.name
    }
}
