//
//  Constant.swift
//  BAPM
//
//  Created by Thành Lã on 12/23/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit

public let isPad: Bool = {return UI_USER_INTERFACE_IDIOM() == .pad}()

struct DefaultValue {
    static let maxImageSize: CGFloat = 600
    static let maxImageCapture = 1 // Số lượng ảnh được phép chụp tối đa
}

enum AppNotification: String {
    case SaveTrackingSignal                 = "save_tracking"
    case updateOrderStatus                  = "update_order_status"
    case updateOrderStatusAndUploadTracking = "update_order_status_and_up_tracking"
    case movingDone                         = "moving_done"
    case tcpStartPing                       = "tcp_start_ping"
    case tcpStopPing                        = "tcp_stop_ping"
    case coordinateUpdated                  = "coordinate_updated"
    case logout                             = "log_out"
    case reloadStaffMonitorList             = "reload_staff_monitor_list"
    
    case tcpRelogin                         = "tcp_relogin"
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}



/**
 Enum Font Size cho text
 */
enum FontSize: CGFloat {
    case small  = 12
    case normal = 15
    case large  = 18
}

/**
 Các loại Font hiển thị trên Iphone
 */
enum FontType: String {
    case latoRegular        = "Lato-Regular"
    case latoMedium         = "Lato-Medium"
    case latoSemibold       = "Lato-Semibold"
    case latoLight          = "Lato-Light"
    case latoBold           = "Lato-Bold"
    case latoBlackItalic    = "Lato-BlackItalic"
    case latoItalic         = "Lato-Italic"
    case avoRegular         = "UTM-Avo"
    case avoItalic          = "UTM-AvoItalic"
}

enum LanguageValue: Int {
    case vietnamese = 0
    case english    = 1
}


typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"












