//
//  RealmImage.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImage: Object {
    dynamic var imageID: String = ""
    dynamic var buildingID: String = ""
    dynamic var createDate: TimeInterval = 0    // Ngày tạo
    dynamic var imageData = NSData()            // Dữ liệu ảnh
    dynamic var note: String = ""               // Ghi chú
    
    public override static func primaryKey() -> String? {
        return "imageID"
    }
    
    public convenience init(image: Image) {
        self.init()
        self.imageID    = image.imageID
        self.buildingID = image.buildingID
        self.createDate = image.createDate
        self.imageData  = image.imageData as NSData
        self.note       = image.note
    }
    
}

extension RealmImage {
    func convertToSyncType() -> Image {
        return Image(realmImage: self)
    }
}
