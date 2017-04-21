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
import SKPhotoBrowser
import CleanroomLogger

protocol BuildingDetailViewControllerDelegate: class {
    func buildingAdded()
}

class BuildingDetailViewController: FormViewController {
    
    enum Size: CGFloat {
        case button = 44, note = 60, imageCell = 160
    }
    
    enum RowTag: String {
        case name       = "Tên địa điểm(*)"
        case address    = "Địa chỉ(*)"
        case phone      = "Số điện thoại"
        case invester   = "Chủ đầu tư"
        case contractor = "Nhà thầu"
        case location   = "Vị trí trên bản đồ"
        case image      = "Image"
    }
    
    var didSetupConstraints = false
    var back: UIBarButtonItem!
    var camera: UIBarButtonItem!
    
    var newBuilding: UIButton!
    
    weak var delegate: BuildingDetailViewControllerDelegate?
    var isNewBuilding = false
    var building: Building!
    
    /// Các thông báo
    var alertController: UIAlertController!
    var alertType: AlertType?
    enum AlertType {
        case deleteImage(UIButton)
        
        func alertTitle() -> String {
            switch self {
            case .deleteImage:
                return "Xóa ảnh"
            }
        }
        
        func alertMessage() -> String {
            switch self {
            case .deleteImage:
                return "Bạn có đồng ý xóa ảnh vừa chọn không?"
            }
        }
    }
    
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
    func addBuilding(_ sender: UIButton) {
        
        if isNewBuilding {
            self.building.createDate = Date().timeIntervalSince1970
        }
        
        guard self.building.name.characters.count > 0, self.building.address.characters.count > 0 else {
            HUD.showMessage("Không được để trống trường có dấu (*)")
            return
        }
        
        DatabaseSupport.shared.insert(building: self.building.convertToRealmType())
        
        delegate?.buildingAdded()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func back(_ sender: UIBarButtonItem) {
        if isNewBuilding {
            DatabaseSupport.shared.deleteBuilding(self.building.buildingID)
        }
        
        NotificationCenter.default.post(name: AppNotification.deleteImage.name, object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func camera(_ sender: UIBarButtonItem) {
        
    }
    
    ///
    func tapOnItemView(_ sender: UIButton) {
        showAlert(type: .deleteImage(sender))
        
    }
    
}

// MARK: PRIVATE METHOD
extension BuildingDetailViewController {
    func showAlert(type: AlertType) {
        let style: UIAlertControllerStyle!
        switch type {
        default:
            style = .alert
        }
        
        alertController = UIAlertController(title: type.alertTitle(), message: type.alertMessage(), preferredStyle: style)
        guard let alert = alertController else { crashApp(message: "Lỗi Alert VC không init được - 22") }
        
        switch type {
            
        case .deleteImage(let button):
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [unowned self] _ in
                Log.message(.debug, message: "tag: \(button.title(for: .normal)) - imageID: \( button.title(for: .selected)))")
                guard let imageID = button.title(for: .selected),
                    let rowTag = button.title(for: .normal), let building = self.building else { return }
                
                self.deleteImageAndUpdateRow(imageID: imageID, imageRowTag: rowTag, building: building)
                
                self.alertType = nil
                
            }))
            
            alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            alertType = type
            
        }
        
    }
    
    ///
    private func deleteImageAndUpdateRow(imageID: String, imageRowTag: String, building: Building) {
        
        guard let imageRow: ImageRow = self.form.rowBy(tag: imageRowTag) else { return }
        
        DatabaseSupport.shared.deleteImage(id: imageID)
        if let idx = building.imageID.index(of: imageID) {
            self.building.imageID.remove(at: idx)
        }
        
        imageRow.options = building.imageID
            .flatMap { DatabaseSupport.shared.getImage(id: $0) }
            .map { $0.convertToSyncType() }
            .flatMap { $0.image }
        
        let imageScrollView = ImageScrollView(frame: CGRect(x: 0, y: 0, width: 60 * 3 + 10 * 3, height: Size.imageCell..))
        
        imageScrollView.arrayPhoto = imageRow.options
        
        guard imageRow.options.count > 0 else {
            imageScrollView.arrayPhoto = [UIImage.Asset.imgHolder.image]
            imageScrollView.isUserInteractionEnabled = false
            imageScrollView.arrayPhotoView.forEach { view in
                view.button.isHidden = true
            }
            imageRow.cell.accessoryView = imageScrollView
            return
        }
        
        zip(imageScrollView.arrayPhotoView, building.imageID).forEach({ (view, id) in
            view.button.setTitle(id, for: .selected)
            view.button.setTitle(imageRow.tag, for: .normal)
            view.button.addTarget(self, action: #selector(self.tapOnItemView(_:)), for: .touchUpInside)
            view.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showImage(_:))))
            view.imageView.isUserInteractionEnabled = true
        })
        
        imageRow.cell.accessoryView = imageScrollView
        
    }
    
    
    
    func showImage(_ sender: UIGestureRecognizer) {
        
        guard let imageView =  sender.view as? UIImageView else { return }
        guard let image = imageView.image else { return }
        
        let photos: [SKPhoto] = [SKPhoto.photoWithImage(image)]
        
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }

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
            make.height.equalTo(Size.button..)
            make.centerX.equalTo(view)
        }
    }
    
    func setupButton() -> UIButton {
        let button = UIButton()
        button.setTitle(isNewBuilding ? "THÊM MỚI" : "LƯU", for: UIControlState())
        button.titleLabel?.font = UIFont(name: FontType.latoSemibold.., size: FontSize.normal--)!
        button.setTitleColor(.main, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.main.cgColor
        button.layer.borderWidth = onePixel()
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.addBuilding(_:)), for: .touchUpInside)
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
        
        let imageRow = setupImageRow(with: building, tag: RowTag.image..)
        section.append(imageRow)
        
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
            .onChange({ (row) in
                
                guard let value = row.value else { return }
                switch tag {
                case RowTag.name..:
                    self.building.name = value
                    
                case RowTag.address..:
                    self.building.address = value
                    
                case RowTag.phone..:
                    self.building.phoneNumber = value
                    
                case RowTag.invester..:
                    self.building.invester = value
                    
                case RowTag.contractor..:
                    self.building.contractor = value
                    
                default: break
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

    /// Row nhiều ảnh
    func setupImageRow(with building: Building, tag: String) -> ImageRow {
        let imageCollectionRow = ImageRow(tag) {
            $0.tag = tag
            
            }
            .cellSetup({ (cell, row) in
                cell.height = { Size.imageCell.. }
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                
                row.options = building.imageID
                    .flatMap { DatabaseSupport.shared.getImage(id: $0) }
                    .map { $0.convertToSyncType() }
                    .flatMap { $0.image }
                
                let imageScrollView = ImageScrollView(frame: CGRect(x: 0, y: 0, width: 60 * 3 + 10 * 3, height: Size.imageCell..))
                
                imageScrollView.arrayPhoto = row.options
                guard row.options.count > 0 else {
                    imageScrollView.arrayPhoto = [UIImage.Asset.imgHolder.image]
                    imageScrollView.isUserInteractionEnabled = false
                    imageScrollView.arrayPhotoView.forEach { view in
                        view.button.isHidden = true
                    }
                    cell.accessoryView = imageScrollView
                    return
                }
                
                zip(imageScrollView.arrayPhotoView, building.imageID).forEach({ (view, id) in
                    view.button.setTitle(id, for: .selected)
                    view.button.setTitle(tag, for: .normal)
                    view.button.addTarget(self, action: #selector(self.tapOnItemView(_:)), for: .touchUpInside)
                    view.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showImage(_:))))
                    view.imageView.isUserInteractionEnabled = true
                })
                
                cell.accessoryView = imageScrollView
                
            })
        
        imageCollectionRow.onChange({ (row) in
            if let image = row.value, let building = self.building {
                row.options.append(image)
                self.insertImageAndUpdateRowImageCollection(imageRow: row, newImage: image, building: building)
            }
            
        })
        
        return imageCollectionRow
        
    }
    
    ///
    private func insertImageAndUpdateRowImageCollection(imageRow: ImageRow, newImage: UIImage, building: Building) {
        
        imageRow.options.forEach { (image) in
            
            if let cropedImage = Utility.shared.resizeImage(newImage), let data = cropedImage.highQualityJPEGNSData {
                
                print("data image: \(data.count / 1000) Kb")
                
                let imageID = UUID().uuidString.lowercased()
                
                let syncImage = Image(
                    imageID: imageID,
                    buildingID: building.buildingID,
                    createDate: Date().timeIntervalSince1970,
                    imageData: data,
                    note: ""
                )
                
                self.building.imageID.append(imageID)
                DatabaseSupport.shared.insert(image: syncImage.convertToRealmType())
            }
        }
        
        /// Update imageRow
        let imageScrollView = ImageScrollView(frame: CGRect(x: 0, y: 0, width: 60 * 3 + 10 * 3, height: Size.imageCell..))
        
        imageScrollView.arrayPhoto = imageRow.options
        zip(imageScrollView.arrayPhotoView, self.building.imageID).forEach({ (view, id) in
            view.button.setTitle(id, for: .selected)
            view.button.setTitle(imageRow.tag, for: .normal)
            view.button.addTarget(self, action: #selector(self.tapOnItemView(_:)), for: .touchUpInside)
            view.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showImage(_:))))
            view.imageView.isUserInteractionEnabled = true
        })
        
        imageRow.cell.accessoryView = imageScrollView
    }
}










