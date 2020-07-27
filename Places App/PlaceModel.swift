//
//  PlaceModel.swift
//  Places App
//
//  Created by Eugene Kiselev on 27.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation

struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let placesName = ["Макдональдс","KFC","Burger King"]
    
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in placesName {
            places.append(Place(name: place, location: "Москва", type: "Ресторан", image: place))
        }
        
        return places
    }
}
