//
//  ItemPhotoView.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/20/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class ItemPhotoView: UIView {
    
    private enum Size: CGFloat {
        case padding10 = 10, button = 20
    }
    
    var imageView: UIImageView!
    var button: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupAllSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: Size.padding10.. / 2,
                                 y: Size.padding10..,
                                 width: bounds.height - Size.padding10.. * 2,
                                 height: bounds.height - Size.padding10.. * 2)
        
        button.frame = CGRect(x: imageView.frame.maxX - Size.button.. * 3 / 4,
                              y: imageView.frame.minY - Size.button.. / 2,
                              width: Size.button..,
                              height: Size.button..)
        
        button.layer.cornerRadius = button.frame.height / 2
    }
}

extension ItemPhotoView {
    func setupAllSubviews() {
        
        
        backgroundColor = .clear
        clipsToBounds = true
        
        
        button = setupButton()
        imageView = setupImageView()
        
        addSubview(imageView)
        addSubview(button)
        
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        
        button.contentMode = .center
        button.setImage(Icon.Nav.delete.tint(.red), for: .normal)
        button.clipsToBounds = true
        button.layer.borderWidth = onePixel()
        button.layer.borderColor = UIColor.red.cgColor
        button.backgroundColor = UIColor.white.alpha(0.9)
        
        return button
    }
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = onePixel()
        imageView.layer.borderColor = UIColor.lightGray.alpha(0.5).cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        return imageView
    }
}
