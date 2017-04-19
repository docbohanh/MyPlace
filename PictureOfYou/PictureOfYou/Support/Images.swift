//
//  Image.swift
//  BAPM
//
//  Created by Thành Lã on 12/23/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit
import PHExtensions


extension UIImage {
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
    /**
     Vẽ ảnh từ text
     */
    class func imageFromText(_ text: String, size: CGSize, textSize: CGFloat = 24, color: UIColor = UIColor.main) -> UIImage {
        
        let data = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let drawText = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        let textFontAttributes = [NSFontAttributeName: UIFont(name: FontType.latoSemibold.., size: textSize)!,
                                  NSForegroundColorAttributeName: color]
        
        let widthOfText = Utility.shared.widthForView(text: text, font: UIFont(name: FontType.latoSemibold.., size: textSize)!, height: size.height)
        let heightOfText = Utility.shared.heightForView(text: text, font: UIFont(name: FontType.latoSemibold.., size: textSize)!, width: size.width)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawText?.draw(in: CGRect(x: (size.width - widthOfText) / 2, y: (size.height - heightOfText) / 2, width: size.width, height: size.height),
                       withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    // Vẽ ảnh từ một màu cho trước
    class func imageFromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!;
    }
    
    func tint(_ color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.set()
        UIRectFill(rect)
        draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: CGFloat(1.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    /**
     Vẽ ảnh hình tròn từ một màu
     */
    class func circle(_ diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx?.setFillColor(color.cgColor)
        ctx?.fillEllipse(in: rect)
        
        ctx?.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}

struct Icon {
    
    struct Nav {
        static var add = UIImage(named: "Add")!
        static var back = UIImage(named: "Back")!
        static var delete = UIImage(named: "Delete")!
        static var done = UIImage(named: "Done")!
        static var edit = UIImage(named: "Edit")!
        static var filter = UIImage(named: "Filter")!
        static var menu = UIImage(named: "Menu")!
        static var right = UIImage(named: "Right")!
        static var trash = UIImage(named: "Trash")!
        static var info = UIImage(named: "Info")!
    }
    
    
}

extension UIImage {
    var uncompressedPNGData: Data?      { return UIImagePNGRepresentation(self)        }
    var highestQualityJPEGNSData: Data? { return UIImageJPEGRepresentation(self, 1.0)  }
    var highQualityJPEGNSData: Data?    { return UIImageJPEGRepresentation(self, 0.75) }
    var mediumQualityJPEGNSData: Data?  { return UIImageJPEGRepresentation(self, 0.5)  }
    var lowQualityJPEGNSData: Data?     { return UIImageJPEGRepresentation(self, 0.25) }
    var lowestQualityJPEGNSData:Data?   { return UIImageJPEGRepresentation(self, 0.0)  }
}

import UIKit

extension UIImage {
    enum Asset: String {
        case _1 = "1"
        case _2 = "2"
        case _3 = "3"
        case _4 = "4"
        case _5 = "5"
        case Back = "back"
        case HertIcon = "HertIcon"
        case PlusIcon = "PlusIcon"
        case ShareIcon = "ShareIcon"
        case TransparentPixel = "TransparentPixel"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}













