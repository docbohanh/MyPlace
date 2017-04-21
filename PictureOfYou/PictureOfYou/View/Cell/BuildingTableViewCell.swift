//
//  BuildingTableViewCell.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions
import MGSwipeTableCell

class BuildingTableViewCell: MGSwipeTableCell {
    
    static let buildingIdentifier = "BuildingCell"
    
    enum Size: CGFloat {
        case Padding15 = 15, Padding10 = 10, Label = 30, Image = 60, icon = 22, padding7 = 7, Padding5 = 5, button = 64
    }
    
    var mainView: UIView!
    var thumbnail: UIImageView!
    var name: UILabel!
    var address: UILabel!
    var labelTime: UILabel!
    var bottomView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        thumbnail.frame = CGRect(x: Size.Padding5.. / 2,
                                 y: Size.Padding5.. / 2,
                                 width: mainView.frame.height + Size.Padding15..,
                                 height: mainView.frame.height - Size.Padding5..)
        
        name.frame = CGRect(x: thumbnail.frame.maxX + Size.Padding5..,
                            y: thumbnail.frame.minY,
                            width: mainView.frame.width - thumbnail.frame.maxX - Size.Padding10.. * 2,
                            height: 40)
        name.sizeToFit()
        
        labelTime.frame =  CGRect(x: thumbnail.frame.maxX + Size.Padding10..,
                                  y: mainView.frame.height - 25,
                                  width: mainView.frame.width - thumbnail.frame.maxX - Size.Padding10.. * 2,
                                  height: 25)
        
        address.frame = CGRect(x: thumbnail.frame.maxX + Size.Padding5..,
                               y: name.frame.maxY,
                               width: mainView.frame.width - thumbnail.frame.maxX - Size.Padding10..,
                               height: 32)
        address.sizeToFit()
        
        bottomView.frame = CGRect(x: 0, y: bounds.height - onePixel(), width: bounds.width, height: onePixel())
        
    }
    
}

extension BuildingTableViewCell {
    
    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        mainView = setupView(bgColor: .white)
        
        thumbnail = setupImage()
        name = setupLabel(textColor: .darkGray,
                          font: UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)!,
                          alignment: .left,
                          numberOfLine: 0)
        
        address = setupLabel(textColor: .gray,
                             font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
                             alignment: .left,
                             numberOfLine: 0)
        
        labelTime = setupLabel(textColor: .darkGray,
                               font: UIFont(name: FontType.latoSemibold.., size: FontSize.small..)!,
                               alignment: .right,
                               numberOfLine: 1)
        
        bottomView = setupView()
        
        mainView.addSubview(thumbnail)
        mainView.addSubview(name)
        mainView.addSubview(address)
        mainView.addSubview(labelTime)
        mainView.addSubview(bottomView)
        
        contentView.addSubview(mainView)
        
    }
    
    func setupView(bgColor: UIColor = UIColor.Misc.seperator) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
    
    
    func setupImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = UIColor.Misc.seperator.cgColor
        imageView.layer.borderWidth = onePixel()
        return imageView
    }
    
    func setupLabel(
        textColor: UIColor = .gray,
        font: UIFont = UIFont(name: FontType.latoRegular.., size: FontSize.small++)!,
        alignment: NSTextAlignment = .left,
        numberOfLine: Int = 0) -> UILabel {
        
        let label = UILabel()
        label.textAlignment = alignment
        label.font = font
        label.numberOfLines = numberOfLine
        label.textColor = textColor
        
        return label
    }
    
}
