//
//  TextFieldTableViewCell.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/20/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class RoadDetailTableViewCell: SeparatorTableViewCell {
    
    var icon: UIImageView!
    var textField: UITextField!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(x: 15, y: (bounds.height - 22) / 2, width: 22, height: 22)
        
        textField.frame = CGRect(x: icon.frame.maxX + 5,
                                 y: (bounds.height - 44) / 2,
                                 width: bounds.width - icon.frame.maxX - 15,
                                 height: 44)
        
    }
    
    fileprivate func setup() {
        icon = setupIcon(Icon.Nav.info)
        textField = setupTextField()
        
        addSubview(icon)
        addSubview(textField)
        
    }
    
    fileprivate func setupIcon(_ image: UIImage) -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = image
        return icon
    }
    
    
    fileprivate func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
        textField.textColor = UIColor.Text.grayMedium
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        
        return textField
    }
    
}
