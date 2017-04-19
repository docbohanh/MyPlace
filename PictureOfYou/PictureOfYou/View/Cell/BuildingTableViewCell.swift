//
//  BuildingTableViewCell.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class BuildingTableViewCell: UITableViewCell {
    
    static let buildingIdentifier = "BuildingCell"
    
    enum Size: CGFloat {
        case Padding15 = 15, Padding10 = 10, Label = 30, Image = 60, icon = 22, padding7 = 7, Padding5 = 5, button = 64
    }
    
    var labelTime: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func layoutSubviews() {
        
        contentView.frame = CGRect(x: Size.Padding10..,
                                   y: Size.Padding5..,
                                   width: bounds.width - Size.Padding10.. * 2,
                                   height: bounds.height - Size.Padding5.. * 2)
        
        imageView?.frame = CGRect(x: Size.Padding5.. / 2,
                                  y: Size.Padding5.. / 2,
                                  width: contentView.frame.height + Size.Padding15..,
                                  height: contentView.frame.height - Size.Padding5..)
        
        guard let imageView = imageView else { return }
        
        textLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding5..,
                                  y: 0,
                                  width: contentView.frame.width - imageView.frame.maxX - Size.Padding10.. * 2,
                                  height: contentView.frame.height / 2)
        
        labelTime.frame =  CGRect(x: imageView.frame.maxX + Size.Padding10..,
                                  y: contentView.frame.height  - Size.Label..,
                                  width: contentView.frame.width - imageView.frame.maxX - Size.Padding10.. * 2,
                                  height: Size.Label..)
        
        detailTextLabel?.frame = CGRect(x: imageView.frame.maxX + Size.Padding5..,
                                        y: contentView.frame.height / 2,
                                        width: contentView.frame.width - imageView.frame.maxX - Size.Padding10..,
                                        height: contentView.frame.height / 2)
        
        
    }
    
}

extension BuildingTableViewCell {
    
    func setup() {
        setupImageView()
        setupTitle()
        
        labelTime = setupLabel()
        contentView.addSubview(labelTime)
        
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 2
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 2, height: 3)
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        
    }
    
    
    func setupImageView() {
        
        imageView?.contentMode = .scaleAspectFill
        imageView?.backgroundColor = UIColor.clear
        imageView?.clipsToBounds = true
        
        imageView?.layer.borderColor = UIColor.lightGray.cgColor
        imageView?.layer.borderWidth = onePixel()
        
    }
    
    func setupIconView() -> UIImageView {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = UIColor.clear
        icon.clipsToBounds = true
        return icon
    }
    
    func setupTitle() {
        
        textLabel?.textAlignment = .left
        textLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)
        textLabel?.numberOfLines = 0
        textLabel?.textColor = UIColor.darkGray
        textLabel?.sizeToFit()
        
        detailTextLabel?.textAlignment = .left
        detailTextLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.small++)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = UIColor.gray
        detailTextLabel?.sizeToFit()
    }
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: FontType.latoRegular.., size: FontSize.small--)
        label.numberOfLines = 1
        label.textColor = UIColor.gray
        
        return label
    }
}
