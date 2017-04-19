//
//  Color.swift
//  BAPM
//
//  Created by Thành Lã on 12/23/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit

extension UIColor {
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    convenience init(_ r: Int, _ g: Int, _ b: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(Double(r)/255.0),
            green: CGFloat(Double(g)/255),
            blue: CGFloat(Double(b)/255),
            alpha: alpha)
    }
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let formattedCode = rgba.replacingOccurrences(of: "#", with: "")
        let formattedCodeLength = formattedCode.characters.count
        if formattedCodeLength != 3 && formattedCodeLength != 4 && formattedCodeLength != 6 && formattedCodeLength != 8 {
            fatalError("invalid color")
        }
        
        var hexValue: UInt32 = 0
        if Scanner(string: formattedCode).scanHexInt32(&hexValue) {
            switch formattedCodeLength {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    static var main: UIColor { return UIColor(rgba: "0087df") } // Màu Xanh da trời
    static var mediumRed: UIColor { return UIColor(rgba: "db4437") }
    static var lightGreen:  UIColor { return UIColor(rgba: "8BC34A") }
    static var greenery: UIColor { return UIColor(rgba: "88b04b") }
    static var lime: UIColor { return UIColor(rgba: "#CDDC39") }
    static var amber: UIColor { return UIColor(rgba: "#FFC107") }
    
    struct Home {
        static var work   = UIColor(rgba: "#e58128")
        static var setting   = UIColor(rgba: "#3f9dae")
        static var help   = UIColor(rgba: "#be4a48")
        static var data   = UIColor(rgba: "#88a80d")
        static var report   = UIColor(rgba: "#726acc")
        static var logout   = UIColor(rgba: "#bc4ab9")
    }
    
    struct Navigation {
        
        static var background   = UIColor(rgba: "#0098cc")
        static var tint         = UIColor.white
        static var main         = UIColor(rgba: "0087df")
        static var sub          = UIColor(rgba: "FF783C")     // Màu đỏ FF783C
        static var highLightText    = UIColor(rgba: "7bbbec")
        
        
        static var searchBarBG  = UIColor(rgba: "#c8c8cd")
        
    }
    
    struct SideBar {
        static var text                 = UIColor.white
        static var selectedText         = UIColor.white
        static var selectedBackground   = UIColor.white.alpha(0.2)
        static var headerBackground     = UIColor(rgba: "1B2430")
        static var cellBackground       = UIColor(rgba: "1B2430")
        
    }
    /**
     Màu nền cho các Text
     */
    struct Text {
        
        static var blackNormal  = UIColor.black
        static var whiteNormal  = UIColor.white
        static var grayNormal   = UIColor(rgba: "6E6E6E")
        static var blackMedium  = UIColor.black.alpha(0.8)
        static var grayMedium   = UIColor.gray.alpha(0.8)
        static var disableText  = UIColor.gray.alpha(0.8)
        static var deselected   = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
        static var subSidebar   = UIColor(rgba: "FFFF00")
        
        // Màu text của empty table
        static var empty = UIColor.gray.alpha(0.7)
        
    }
    
    /**
     Màu nền cho các Table
     */
    struct Table {
        static var empty = UIColor(rgba: "ecf0f2")
        
        static var plain = UIColor(rgba: "#eeeeee")
        
        static var group = UIColor(rgba: "#EFEFEF")
        
        
        static var delete = UIColor(rgba: "FF5252")
        static var regard = UIColor(rgba: "297FC8")
        static var detail = UIColor(rgba: "8BC34A")
    }
    
    static var tracking: UIColor { return UIColor(rgba: "5588FF") }
    
    struct General {
        static var separator = UIColor(rgba: "c8c7cc")
        static var calendar = UIColor(rgba: "ff3b30")
    }
    
    struct Misc {
        static var seperator = UIColor(rgba: "DDD")
    }
    
    struct Background {
        static var textView = UIColor(rgba: "f8f8f8")
        
        static var notification = UIColor(rgba: "333333")
    }
    
    struct Segment {
        //        static var selectedText = UIColor(rgba: "107FC9")
        
        static var selectedText = UIColor(rgba: "3B5998")
        
        static var deselectedText = UIColor.white
        
        static var selectedBackground = UIColor.clear
        
        static var deselectedBackground = UIColor.clear
        
        static var devider = UIColor.clear
        
        static var background = UIColor.clear
        
        static var indicator = UIColor.white
    }
}
