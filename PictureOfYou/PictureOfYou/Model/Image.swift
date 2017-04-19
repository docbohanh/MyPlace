//
//  Image.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation

struct Image {
    var imageID: String
    var buildingID: String
    var createDate: TimeInterval    // Ngày tạo
    var imageData: Data             // Dữ liệu ảnh
    var note: String                // Ghi chú
    
    init(imageID: String, buildingID: String, createDate: TimeInterval, imageData: Data, note: String) {
        self.imageID    = imageID
        self.buildingID = buildingID
        self.createDate = createDate
        self.imageData  = imageData
        self.note       = note
    }
    
    init(realmImage: RealmImage) {
        self.imageID    = realmImage.imageID
        self.buildingID = realmImage.buildingID
        self.createDate = realmImage.createDate
        self.imageData  = realmImage.imageData as Data
        self.note       = realmImage.note
    }
    
    var image: UIImage? {
        return UIImage(data: imageData)
    }
}

extension Image {
    func convertToRealmType() -> RealmImage {
        return RealmImage(image: self)
    }
}
