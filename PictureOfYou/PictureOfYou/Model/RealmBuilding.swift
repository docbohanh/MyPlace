//
//  RealmBuilding.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
import RealmSwift

class RealmBuilding: Object {
    dynamic var buildingID: String = ""
    dynamic var name: String = ""               // Tên công trình
    dynamic var address: String = ""            // Địa chỉ
    dynamic var invester: String = ""           // Chủ đầu tư
    dynamic var contractor: String = ""         // Nhà thầu
    dynamic var phoneNumber: String = ""        // Số diện thoại
    dynamic var createDate: TimeInterval = 0    // Ngày tạo
    dynamic var imageID: String = ""            // Các ID Ảnh, dạng imageID1,imageID2...
    
    public override static func primaryKey() -> String? {
        return "buildingID"
    }
    
    public convenience init(building: Building) {
        self.init()
        self.buildingID = building.buildingID
        self.name       = building.name
        self.address    = building.address
        self.invester   = building.invester
        self.contractor = building.contractor
        self.phoneNumber = building.phoneNumber
        self.createDate = building.createDate
        self.imageID    = building.imageIDs
    }
    
}

extension RealmBuilding {
    func convertToSyncType() -> Building {
        return Building(
            building: self.buildingID,
            name: self.name,
            address: self.address,
            invester: self.invester,
            contractor: self.contractor,
            phoneNumber: self.phoneNumber,
            createDate: self.createDate,
            imageID: self.imageID.components(separatedBy: ","))
    }
}
