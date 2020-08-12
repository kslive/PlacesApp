//
//  StorageManager.swift
//  Places App
//
//  Created by Eugene Kiselev on 28.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
