//
//  TextViewTableViewCell.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/20/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

class RoadNoteTableViewCell: SeparatorTableViewCell {
    
    enum Size: CGFloat {
        case textView = 40, padding10 = 10
    }
    
    var textView: UITextView!
    
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
        
        textView.frame = CGRect(x: Size.padding10..,
                                y: (bounds.height - Size.textView..) / 2,
                                width: bounds.width - Size.padding10.. * 2,
                                height: Size.textView..)
        
    }
    
    fileprivate func setup() {
        
        textView = setupTextView()
        addSubview(textView)
        
    }
    
    fileprivate func setupTextView() -> UITextView {
        let textView = KMPlaceholderTextView()
        textView.backgroundColor = UIColor.white
        textView.textAlignment = .left
        textView.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal--)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .sentences
        textView.sizeToFit()
        textView.placeholder = "Ghi chú"
        
        return textView
    }
}
