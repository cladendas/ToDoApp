//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by cladendas on 10.05.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    
    var geocoder = CLGeocoder()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    var dateFormater: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }
    
    func save() {
        let titleString = titleTextField.text
        let locationString = locationTextField.text
        let date = dateFormater.date(from: dateTextField.text!) //нужна проверка для опционала
        let descriptionString = descriptionTextField.text
        let addressString = addressTextField.text
        geocoder.geocodeAddressString(addressString!) { [unowned self] (placemarks, error) in //нужна проверка для опционала, [unowned self] делает ссылку слабой для предотвращения цикла сильных ссылок
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!, coordinate: coordinate)
            let task = Task(title: titleString!, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
        }
    }
    
}
