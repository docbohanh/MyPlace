//
//  Utility.swift
//  BAPM
//
//  Created by Thành Lã on 12/23/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit
import PHExtensions
import CleanroomLogger
import CoreLocation

public func crashApp(message:String) -> Never  {
    let log = "CRASH - " + message
    Log.message(.error, message: log)
    fatalError(log)
}

/// Chạy hàm sau khoảng thời gian `delay`
public func delay(_ delay: Double, closure:@escaping () -> () ) {    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

struct Utility {
    
    static let shared = Utility()
    
    /**
     Tính độ cao cho text
     */
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    /**
     Tính chiều rộng của text
     */
    func widthForView(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0,  width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    /// Căn giữa `title` và `image` cho button
    func centeredTextAndImage(for button: UIButton, spacing: CGFloat = 3.0) {
        
        let imageSize: CGSize = button.imageView!.image!.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
        
    }
    
    /**
     Chỉnh lại giao diện navigation bar
     
     - parameter navController:
     */
    func configureAppearance(navigation navController: UINavigationController, bgColor: UIColor = UIColor.Navigation.background) {
                
        navController.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: FontType.latoRegular.., size: FontSize.large--)!,
            NSForegroundColorAttributeName: UIColor.white]
        navController.navigationBar.barTintColor = bgColor
        
        navController.navigationBar.barStyle = .black
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navController.navigationBar.isTranslucent = true
    }
    
    /// Lấy `GMSPath` từ mảng `coordinate`
    func getGMSPath(from coordinate: [Coordinate]) -> GMSPath {
        let path = GMSMutablePath()
        coordinate.forEach { path.add($0) }
        return path
    }
    
    
    /**
     Tính khoảng các giữa 2 điểm
     */
    func calculateDistanceMetersFromCoordinate(_ from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
    
    
    /*
     Format khoảng cách
     */
    func stringFromConvertDistanceToText(_ distance: Double, metersAccuracy: Bool = true) -> String {
        if distance < 1000 && metersAccuracy {
            return distance.toString(0) + " " + "m"
        } else {
            return (distance / 1000).toString(1) + " " + "Km"
        }
    }
    
    
    /// Giảm kích thước ảnh
    func resizeImage(_ image: UIImage) -> UIImage? {
        
        /// Nếu kích thước ảnh nhỏ hơn DefaultValue.maxImageSize thì giữ nguyên kích thước
        if image.size.width < DefaultValue.maxImageSize && image.size.height < DefaultValue.maxImageSize {
            return image
        }
        
        let ratio = image.size.width / image.size.height
        
        var newSize = CGSize(width: 0, height: 0)
        
        
        /// Nếu kích thước ảnh lớn hơn DefaultValue.maxImageSize thì trả về DefaultValue.maxImageSize
        if image.size.width >= DefaultValue.maxImageSize && ratio > 1 {
            newSize.width = DefaultValue.maxImageSize
            newSize.height = DefaultValue.maxImageSize / ratio
            
        }
        
        if image.size.height >= DefaultValue.maxImageSize && ratio < 1 {
            newSize.height = DefaultValue.maxImageSize
            newSize.width = DefaultValue.maxImageSize * ratio
        }
        
        /// Nếu tỉ lệ là 1:1
        if ratio == 1 {
            newSize.width = DefaultValue.maxImageSize
            newSize.height = DefaultValue.maxImageSize
        }
        
        /// Làm tròn kích thước ảnh
        newSize.width = round(newSize.width)
        newSize.height = round(newSize.height)
        
        UIGraphicsBeginImageContext(CGSize(width: newSize.width, height: newSize.height))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Cắt ảnh
    func cropImage(_ image: UIImage, toSize size: CGSize, maxSize: CGFloat = DefaultValue.maxImageSize) -> UIImage {
        
        var newSize: CGSize
        /**
         *  Resize xuống 1024 x 1024
         */
        if image.size.width >= image.size.height { newSize = CGSize(width: maxSize, height: maxSize * image.size.height / image.size.width) }
        else { newSize = CGSize(width: maxSize * image.size.width / image.size.height, height: maxSize) }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        /**
         *  Crop to size
         */
        
        let x = ((newImage?.cgImage?.width)! - Int(size.width)) / 2
        let y = ((newImage?.cgImage?.height)! - Int(size.height)) / 2
        let cropRect = CGRect(x: x, y: y, width: Int(size.height), height: Int(size.width))
        let imageRef = newImage?.cgImage?.cropping(to: cropRect)
        
        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: (newImage?.imageOrientation)!)
        return cropped
        
    }
    
    ///Check phone number
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        //        let tenNumberArray = ["12","162","163","164","165","166","167","168","169","186","188","199"]
        //        let nineNumberArray = ["9","86", "88", "89"]
        
        var string = phoneNumber.trimmingCharacters(in: CharacterSet.whitespaces)
            .replacingOccurrences(of: " ", with: "")
        
        
        if string.hasPrefix("0") {
            string =  string.substring(with: Range<String.Index>(string.characters.index(string.startIndex, offsetBy: 1)..<string.endIndex))
        } else if string.hasPrefix("84") {
            string = string.substring(with: Range<String.Index>(string.characters.index(string.startIndex, offsetBy: 2)..<string.endIndex))
        } else if string.hasPrefix("+84") {
            string =  string.substring(with: Range<String.Index>(string.characters.index(string.startIndex, offsetBy: 3)..<string.endIndex))
        }
        
        ///So sánh nếu cho phép là 10 số và 11 số
        return string.characters.count == 9 || string.characters.count == 10
        
    }
    
    /// Kiểm tra định dạng email
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    ///
    func resetDataWhenRejectedByServer() {
        
        AppData.shared.token = ""
        AppData.shared.account = nil
        AppData.shared.updateWorkingStatus(userStatus: .idle, currentAction: 0)
        
        TrackingManager.shared.orderID = ""
        TrackingManager.shared.tracking = nil
        
        Defaults[.isLogin] = false
        
    }
    
    /**
     Gọi điện thoại
     */
    func callPhoneNumber(_ phoneNumber: String) {
        let phone = phoneNumber
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
        
        guard phone.characters.count > 0 else { return }
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            log("on simulator - not calling")
        #else
            let tel = "tel://" + phone
            UIApplication.shared.openURL(URL(string: tel)!)
        #endif
    }
    
    /**
     Tạo local notification
     
     - parameter message:
     */
    func presentLocalNotification(after time: TimeInterval = 1, message: String) {
        
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = Date(timeIntervalSinceNow: time)
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    
    
    /**
     Đổi "đ" -> "d"
     */
    
    func stringFromReplaceTheD(_ string: String) -> String {
        let charSet = CharacterSet(charactersIn: "đ")
        let newString = NSString(format: "%@", string)
        if newString.rangeOfCharacter(from: charSet).location != NSNotFound {
            return string.lowercased().replacingOccurrences(of: "đ", with: "d")
        }
        return string
    }
    
    /**
     *  Loại bỏ dấu câu, dấu của từ, chuyển thành chữ thường
     *  Phục vụ mục đích tạo ra search text để insert vào DB
     */
    
     func normalizeString(_ string: String) -> String {
        
        guard let data = Utility.shared.stringFromReplaceTheD(string).lowercased().data(using: .ascii, allowLossyConversion: true) else { return ""}
        
        guard let newString = String(data: data, encoding: .ascii) else { return "" }
        
        return newString
    }
    
}








