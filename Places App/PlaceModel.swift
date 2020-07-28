//
//  PlaceModel.swift
//  Places App
//
//  Created by Eugene Kiselev on 27.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    let placesName = ["Макдональдс","KFC","Burger King"]
    
    func savePlaces() {
                
        for place in placesName {
            
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
            
            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "Moscow"
            newPlace.type = "Bar"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }
    }
}
