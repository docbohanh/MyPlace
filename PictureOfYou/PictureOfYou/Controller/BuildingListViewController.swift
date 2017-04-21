//
//  BuildingListViewController.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//
import UIKit
import SnapKit
import PreviewTransition
import MGSwipeTableCell
import PHExtensions
import CleanroomLogger

class BuildingListViewController: UIViewController {
    
    enum Size: CGFloat {
        case cell = 100
    }
    
    var didSetupConstraints = false
    var building: [Building] = []
    
    var export: UIBarButtonItem!
    var add: UIBarButtonItem!
    
    var tableView: UITableView!
    
    fileprivate var dateTimeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        return formatter
    }()
    
    fileprivate var timeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        building = DatabaseSupport.shared.getAllBuildings().map { $0.convertToSyncType() }
        
//        building = [
//            Building(
//                buildingID: UUID().uuidString,
//                name: "Cty TNHH phát triển công nghệ điện tử Bình Anh Electronics",
//                address: "Số 30 ngách 88/61 Giáp Nhị - Thịnh Liệt - Hoàng Mai – Hà Nội",
//                invester: "Đào Thanh Anh",
//                contractor: "Phùng Thị Thanh Bình",
//                phoneNumber: "0987654321",
//                createDate: Date().timeIntervalSince1970 - 2.day,
//                imageID: ["Image1"]
//            )
//        ]
        
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
extension BuildingListViewController {
    func export(_ sender: UIBarButtonItem) {
        
    }
    
    func add(_ sender: UIBarButtonItem) {
        let detailVC = BuildingDetailViewController()
        detailVC.delegate = self
        detailVC.isNewBuilding = true
        detailVC.building = Building(
            buildingID: UUID().uuidString,
            name: "",
            address: "",
            invester: "",
            contractor: "",
            phoneNumber: "",
            createDate: 0,
            imageID: [])
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: PRIVATE METHOD
extension BuildingListViewController {
    fileprivate func stringFromPastTime(_ time: TimeInterval) -> String {
        let deltaTime = Date().timeIntervalSince1970 - time
        
        guard deltaTime > 1.day else {
            return Utility.shared.stringFromPastTimeToText(time)
        }
        
        if deltaTime < 2.days {
            return timeFormatter.string(from: Date(timeIntervalSince1970: time)) + " hôm qua"
        } else if deltaTime < 3.days {
            return timeFormatter.string(from: Date(timeIntervalSince1970: time)) + " hôm kia"
        } else {
            return dateTimeFormatter.string(from: Date(timeIntervalSince1970: time))
        }
        
    }
    
    func reloadTableData() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
            
            self.building = DatabaseSupport.shared.getAllBuildings().map { $0.convertToSyncType() }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

// MARK: TABLE DATASOURCE
extension BuildingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return building.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuildingTableViewCell.buildingIdentifier, for: indexPath) as! BuildingTableViewCell
        configFor(cell, with: building[indexPath.row])
        return cell
    }
    
    fileprivate func configFor(_ cell: BuildingTableViewCell, with building: Building) {
        cell.selectionStyle = .none
        
        cell.thumbnail.image = UIImage.Asset.empty.image
        
        cell.name.text = Utility.shared.split(longString: building.name, maxCharacter: 45)
        
        cell.address.text = Utility.shared.split(longString: building.address, maxCharacter: 49)
        
        cell.labelTime.text = stringFromPastTime(building.createDate)
        
        if let realmImage = DatabaseSupport.shared.getImageOf(buildingID: building.buildingID).last {
            let syncImage = realmImage.convertToSyncType()
            if let thumbnail = syncImage.image {
                cell.thumbnail.image = thumbnail
            }
        }
        
        cell.delegate = self
        
        let buttonDelete = setupMGSwipeButton(title: "Xóa", image: Icon.Nav.trash, bgColor: UIColor.Table.delete)
        cell.rightButtons = [buttonDelete]
    }
}


// MARK: TABLE DELEGATE
extension BuildingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cell..
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = BuildingDetailViewController()
        detailVC.delegate = self
        detailVC.building = building[indexPath.row]
        detailVC.title = "Chi tiết"
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

//-------------------------------------
// MARK: - MGSWIPE DELEGATE
//-------------------------------------
extension BuildingListViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        guard let indexPath = tableView.indexPath(for: cell) else { crashApp(message: "Không lấy đc indexPath từ Cell")}
                
        switch index {
            
        case 0: // Xóa công trình
                        
            DatabaseSupport.shared.deleteBuilding(building[indexPath.row].buildingID)
            
            UIView.animate(withDuration: 0.3.second, animations: {
                self.reloadTableData()
            })
            
            
        default: break
            
        }
        
        return true
        
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, shouldHideSwipeOnTap point: CGPoint) -> Bool {
        return true
        
    }
    
}

// MARK: BUILDING DETAIL DELEGATE
extension BuildingListViewController: BuildingDetailViewControllerDelegate {
    func buildingAdded() {
        reloadTableData()
    }
}

// MARK: SETUP VIEW
extension BuildingListViewController {
    func setupAllSubview() {
        export = setupBarButtonItem(UIImage.Asset.cloud.image, selector: #selector(self.export(_:)))
        add = setupBarButtonItem(Icon.Nav.add, selector: #selector(self.add(_:)))
        navigationItem.leftBarButtonItem = export
        navigationItem.rightBarButtonItem = add
        
        title = "My Place"
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tableView = setupTableView()
        view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadTableData),
                                               name: Notification.Name(AppNotification.deleteImage..),
                                               object: nil)
        
    }
    
    func setupAllConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupTableView() -> UITableView {
        let table = UITableView()
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.groupTableViewBackground
        table.register(BuildingTableViewCell.self, forCellReuseIdentifier: BuildingTableViewCell.buildingIdentifier)
        return table
    }
    
    /// Setup Bar Button
    fileprivate func setupBarButtonItem(_ image: UIImage, selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        button.tintColor = UIColor.white
        return button
    }
    
    
    fileprivate func setupMGSwipeButton(title: String = "", image: UIImage, bgColor: UIColor = UIColor.main) -> MGSwipeButton {
        let button = MGSwipeButton(title: title, icon: image.tint(.white), backgroundColor: bgColor)
        
        let buttonWidth = Utility.shared.widthForView(text: title, font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!, height: 20)
        button.frame = CGRect(x: 0, y: 10, width: max(buttonWidth + 20, Size.cell..), height: Size.cell.. - 20)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.small++)
        Utility.shared.centeredTextAndImage(for: button)
        
        return button
    }
    
}
