//
//  DatabaseSupport.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
import RealmSwift
import CleanroomLogger

public class DatabaseSupport {
    public static let shared = DatabaseSupport()

}

extension DatabaseSupport {
    func getAllBuildings() -> [RealmBuilding] {
        do {
            return try Realm().objects(RealmBuilding.self).toArray()
        }
        catch {
            Log.message(.error, message: "getAllBuildings error: \(error)")
            return []
        }
    }
    
    func getBuilding(id: String) -> RealmBuilding? {
        do {
            return try Realm().objects(RealmBuilding.self)
                .toArray()
                .first { $0.buildingID == id }
        }
        catch {
            Log.message(.error, message: "getBuilding error: \(error)")
            return nil
        }
    }
    
    func insert(building: RealmBuilding) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(building, update: true)
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot insert Image: \(error)")
        }
    }
    
    func deleteBuilding(_ id: String) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let realmBuilding = realm.object(ofType: RealmBuilding.self, forPrimaryKey: id) else { return }
                realm.delete(realmBuilding)
                Log.message(.debug, message: "Realm - deleted buildingID: \(id)")
                
                let realmImage = DatabaseSupport.shared.getAllImages().filter { $0.buildingID == id }
                realm.delete(realmImage)
                Log.message(.debug, message: "Realm - deleted realmImage")
                
            }
        }
        catch {
            Log.message(.error, message: "Realm - delete building error: \(error)")
            
        }
    }
    
    
    func getAllImages() -> [RealmImage] {
        do {
            return try Realm().objects(RealmImage.self).toArray()
        }
        catch {
            Log.message(.error, message: "getAllImages error: \(error)")
            return []
        }
    }
    
    func getImage(id: String) -> RealmImage? {
        do {
            return try Realm().objects(RealmImage.self)
                .toArray()
                .first { $0.imageID == id }
        }
        catch {
            Log.message(.error, message: "getImage error: \(error)")
            return nil
        }
    }
    
    func getImageOf(buildingID: String) -> [RealmImage] {
        do {
            return try Realm().objects(RealmImage.self)
                .toArray()
                .filter { $0.buildingID == buildingID }
        }
        catch {
            Log.message(.error, message: "getImage error: \(error)")
            return []
        }
    }
    
    func insert(image: RealmImage) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(image, update: true)
            }
        }
        catch {
            Log.message(.error, message: "Realm - Cannot insert Image: \(error)")
        }
    }
    
    func deleteImage(id: String) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let image = realm.object(ofType: RealmImage.self, forPrimaryKey: id) else { return }
                realm.delete(image)
                Log.message(.debug, message: "Realm - delete imageID: \(id)")
            }
        }
        catch {
            Log.message(.error, message: "Realm - delete image error: \(error)")
            
        }
    }
    
    func deleteImage(_ images: [RealmImage]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(images)
                Log.message(.debug, message: "Realm - delete imageID: \(images.map { $0.imageID })")
            }
        }
        catch {
            Log.message(.error, message: "Realm - delete [image] error: \(error)")
            
        }
    }
    
}
