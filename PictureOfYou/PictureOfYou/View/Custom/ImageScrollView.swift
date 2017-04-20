//
//  ImageScrollView.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/20/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import PHExtensions

protocol ImageScrollViewDelegate: class {
    func selectedImage(image: UIImage, position: Int)
    func deleteImage(position: Int)
}

class ImageScrollView: UIView {
    
    enum Size: CGFloat {
        case padding10 = 10, label = 22
    }
    
    /// VIEW
    var scrollView: UIScrollView!
    var arrowLeft: UIButton!
    var arrowRight: UIButton!
    
    /// VAR
    weak var delegate: ImageScrollViewDelegate?
    
    /**
     Số lượng ảnh tối đa hiển thị trong 1 page
     */
    let maxItem: CGFloat = 3
    
    
    var selectedPosition: Int = 0
    var arrayPhotoView: [ItemPhotoView] = []
    var arrayPhoto: [UIImage] = [] {
        didSet {
            updateView()
            layoutSubviews()
        }
    }
    
    
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
        scrollView.frame = bounds
        
        arrowLeft.frame = CGRect(x: 0, y: 0, width: 20, height: 40)
        arrowRight.frame = CGRect(x: bounds.width - 20, y: 0, width: 20, height: 40)
        arrowLeft.center.y = scrollView.center.y
        arrowRight.center.y = scrollView.center.y
        
        
        /// Độ rộng của 1 view item        
        let imgWidth = bounds.width / min(maxItem, CGFloat(arrayPhoto.count))
        
        scrollView.contentSize = CGSize(width: CGFloat(arrayPhoto.count) * imgWidth, height: scrollView.frame.height)
        arrowRight.isHidden = scrollView.contentSize.width <= bounds.width
        
        
        arrayPhotoView.forEach { view in
            view.frame = CGRect(x: imgWidth * CGFloat(view.tag),
                                y: 0,
                                width: imgWidth,
                                height: scrollView.frame.height)
        }
        
    }
}


//-------------------------------
// MARK: - SELECTOR
//-------------------------------
extension ImageScrollView {
    
    func tapOnItemView(_ sender: UITapGestureRecognizer) {
        
        guard let view = sender.view else { return }
        changeSelectedVehicleViewToPositon(view.tag)
    }
    
    func deleteImage(_ sender: UIButton) {
        delegate?.deleteImage(position: sender.tag)
        
    }
}

//-------------------------------
// MARK: - PRIVATE METHOD
//-------------------------------
extension ImageScrollView {
    
    /**
     Update Images
     */
    fileprivate func updateView() {
        guard arrayPhoto.count > 0 else { return }
        
        arrayPhotoView.forEach { $0.removeFromSuperview() }
        arrayPhotoView.removeAll()
        
        selectedPosition = 0
        
        for (index, vehicle) in arrayPhoto.enumerated() {
            let view = setupItemVehicleView(vehicle, tag: index)
            arrayPhotoView.append(view)
            scrollView.addSubview(view)
        }
    }
    
    /**
     Thay đổi vị trí của Vehicle Selected
     */
    func changeSelectedVehicleViewToPositon(_ position: Int) {
        guard arrayPhoto.count > 0 else { return }
        guard position != selectedPosition else { return }
        
        selectedPosition = position
        delegate?.selectedImage(image: arrayPhoto[position], position: position)
        
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .overrideInheritedDuration,
            animations: ({
                self.arrayPhotoView.forEach { $0.button.isHidden = ($0.tag == 0) }
            }),
            completion: { _ in
        })
    }
    
    
    /**
     Hàm ẩn hiện view
     */
    fileprivate func setVisibilityOf(_ view: UIView, to visible: Bool, duration: TimeInterval = 0.3.second, completion: (() -> Void)? = nil) {
        
        if visible && view.isHidden { view.isHidden = false }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                view.alpha = visible ? 1.0 : 0.0
        },
            completion: { finished in
                if !visible { view.isHidden = true }
                if let completion = completion { completion() }
        })
        
    }
}

//-------------------------------
// MARK: - SCROLL DELEGATE
//-------------------------------
extension ImageScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setVisibilityOf(arrowLeft, to: scrollView.contentOffset.x > 0)
        setVisibilityOf(arrowRight, to: scrollView.contentOffset.x + Size.padding10.. < scrollView.contentSize.width - scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let widthCarView = bounds.width / min(maxItem, CGFloat(arrayPhoto.count))
        
        guard scrollView.contentOffset.x.truncatingRemainder(dividingBy: widthCarView) != 0 else { return }
        let pos = Int(scrollView.contentOffset.x / widthCarView + 0.5)
        scrollView.scrollRectToVisible(CGRect(x: widthCarView * CGFloat(pos),
                                              y: 0,
                                              width: scrollView.frame.width,
                                              height: scrollView.frame.height), animated: true)
    }
}

extension ImageScrollView {
    func setupAllSubviews() {
        
        clipsToBounds = true
        
        setupScrollView()
        arrowLeft = setupArrowButton(Icon.Nav.back, isHidden: true)
        arrowRight = setupArrowButton(Icon.Nav.right)
        
        addSubview(arrowLeft)
        addSubview(arrowRight)
        
        
        
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
    }
    
    func setupArrowButton(_ image: UIImage, isHidden: Bool = false) -> UIButton {
        let button = UIButton()
        button.isHidden = isHidden
        button.setImage(image.tint(UIColor.Navigation.main), for: .normal)
        button.contentMode = .center
        return button
    }
    
    func setupItemVehicleView(_ photo: UIImage, tag: Int) -> ItemPhotoView {
        let view = ItemPhotoView()
        view.tag = tag
        view.button.tag = tag
        view.imageView.image = photo
        view.isUserInteractionEnabled = true
        //        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOnItemView(_:))))
        view.button.addTarget(self, action: #selector(self.deleteImage(_:)), for: .touchUpInside)
        
        return view
    }
}
