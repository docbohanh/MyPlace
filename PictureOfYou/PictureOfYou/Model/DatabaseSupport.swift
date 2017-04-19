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
        }
    }
    
    func getBuilding(id: String) -> RealmBuilding? {
        do {
            return try Realm().objects(RealmBuilding.self)
                .toArray()
                .first { $0.buildingID == id }
        }
        catch {
            return nil
            Log.message(.error, message: "getBuilding error: \(error)")
        }
    }
    
    
    func getAllImages() -> [RealmImage] {
        do {
            return try Realm().objects(RealmImage.self).toArray()
        }
        catch {
            Log.message(.error, message: "getAllImages error: \(error)")
        }
    }
    
    func getImage(id: String) -> RealmImage? {
        do {
            return try Realm().objects(RealmImage.self)
                .toArray()
                .first { $0.imageID == id }
        }
        catch {
            return nil
            Log.message(.error, message: "getImage error: \(error)")
        }
    }
    
    func getImageOf(buildingID: String) -> [RealmImage] {
        do {
            return try Realm().objects(RealmImage.self)
                .toArray()
                .filter { $0.buildingID == buildingID }
        }
        catch {
            return []
            Log.message(.error, message: "getImage error: \(error)")
        }
    }
    
}
