//
//  Building.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation

struct Building {
    var buildingID: String
    var name: String                // Tên công trình
    var address: String             // Địa chỉ
    var invester: String            // Chủ đầu tư
    var contractor: String          // Nhà thầu
    var phoneNumber: String         // Số diện thoại
    var createDate: TimeInterval    // Ngày tạo
    var imageID: [String]           // Các ID Ảnh, dạng imageID1,imageID2...
    
    var imageIDs: String {
        var result: String = ""
        
        for (i) in 0..<imageID.count - 1 {
            result.append(imageID[i] + ",")
        }
        
        result.append(imageID[imageID.count - 1])
        
        return result
        
    }

    init(building: String,
         name: String,
         address: String,
         invester: String,
         contractor: String,
         phoneNumber: String,
         createDate: TimeInterval,
         imageID: [String]) {
        
        self.buildingID = buildingID
        self.name = name
        self.address = address
        self.invester = invester
        self.contractor = contractor
        self.phoneNumber = phoneNumber
        self.createDate = createDate
        self.imageID = imageID
    }
    
}

extension Building {
    func convertToRealmType() -> RealmBuilding {
        return RealmBuilding(building: self)
    }
}
