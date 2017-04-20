//
//  BuildingDetailViewController.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/20/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import Eureka

protocol BuildingDetailViewControllerDelegate: class {
    func buildingAdded()
}

class BuildingDetailViewController: FormViewController {
    
    enum Size: CGFloat {
        case button = 44, note = 60
    }
    
    enum RowTag: String {
        case name       = "Tên địa điểm"
        case address    = "Địa chỉ"
        case phone      = "Số điện thoại"
        case invester   = "Chủ đầu tư"
        case contractor = "Nhà thầu"
    }
    
    var didSetupConstraints = false
    var back: UIBarButtonItem!
    var camera: UIBarButtonItem!
    
    var newBuilding: UIButton!
    
    weak var delegate: BuildingDetailViewControllerDelegate?
    var isNewBuilding = false
    var building: Building!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAllSubview()
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
        
    }

}

// MARK: SELECTOR
extension BuildingDetailViewController {
    func newBuilding(_ sender: UIButton) {
        
        delegate?.buildingAdded()
    }
    
    func back(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func camera(_ sender: UIBarButtonItem) {
        
    }
    
}

// MARK: PRIVATE METHOD
extension BuildingDetailViewController {
    
}

// MARK: SETUP VIEW
extension BuildingDetailViewController {
    func setupAllSubview() {
        
        back = setupBarButtonItem(Icon.Nav.back, selector: #selector(self.back(_:)))
        camera = setupBarButtonItem(UIImage.Asset.camera.image, selector: #selector(self.camera(_:)))
        navigationItem.leftBarButtonItem = back
        navigationItem.rightBarButtonItem = camera
        
        newBuilding = setupButton()
        view.addSubview(newBuilding)
        
        setupFormEureka()
    }
    
    func setupAllConstraints() {
        newBuilding.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.width.equalTo(view.frame.width - 20)
            make.height.equalTo(isNewBuilding ? Size.button.. : 0)
        }
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.setTitle("TẠO MỚI", for: UIControlState())
        button.titleLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal..)!
        button.setTitleColor(.main, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.main.cgColor
        button.layer.borderWidth = onePixel()
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.newBuilding(_:)), for: .touchUpInside)
        return button
    }
    
    /// Setup Bar Button
    fileprivate func setupBarButtonItem(_ image: UIImage, selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        button.tintColor = UIColor.white
        return button
    }
    
}

// MARK: SETUP EUREKA CELL
extension BuildingDetailViewController {
    func setupFormEureka() {
        
        guard let building = building else { return }
        
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Size.button.., right: 0)
        let section = setupSection()
        form.append(section)
        
        [RowTag.name.., RowTag.address.., RowTag.phone.., RowTag.invester.., RowTag.contractor..].forEach { rowTag in
            let row = setupTextFloatLabelRow(building: building, tag: rowTag)
            section.append(row)
        }
        
    }
    
    ///
    func setupSection() -> Section {
        return Section() {
            
            var header = HeaderFooterView<UIView>(.class)
            
            header.height = { onePixel() }
            $0.header = header
            
            var footer = HeaderFooterView<UIView>(.class)
            footer.height = { onePixel() }
            $0.footer = footer
            
        }
        
    }
    
    func setupTextFloatLabelRow(building: Building, tag: String) -> TextFloatLabelRow {
        return TextFloatLabelRow(tag) { row in
            
                row.tag = tag
                row.title = tag
                
                switch tag {
                case RowTag.name..:
                    row.value = building.name
                    
                case RowTag.address..:
                    row.value = building.address
                    
                case RowTag.phone..:
                    row.value = building.phoneNumber
                    
                case RowTag.invester..:
                    row.value = building.invester
                    
                case RowTag.contractor..:
                    row.value = building.contractor
                    
                default: break
                }
            
            
            }
            .cellSetup({ (cell, row) in
                self.configCell(forCell: cell)
                if row.tag == RowTag.phone.. {
                    cell.textField.keyboardType = .phonePad
                }
            })
        
    }
    
    ///
    func configCell(forCell cell: TextFloatLabelCell) {
        
        cell.textLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.normal..)
        cell.textLabel?.textColor = UIColor.darkGray
        
        cell.textField.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal++)
        cell.textField.textColor = UIColor.darkGray.alpha(0.9)
        cell.textField.clearButtonMode = .whileEditing
        cell.textField.autocorrectionType = .no
        cell.textField.autocapitalizationType = .words
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
    }

    
}










