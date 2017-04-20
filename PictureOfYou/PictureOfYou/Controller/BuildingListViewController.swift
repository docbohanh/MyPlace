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

class BuildingListViewController: UIViewController {
    
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
        
        building = [
            Building(
                buildingID: UUID().uuidString,
                name: "Công ty TNHH TM & XD Trung Chính",
                address: "Ngõ 61 Bằng Liệt, Bằng A, Hoàng Liệt",
                invester: "Nguyễn Văn A",
                contractor: "Trần Quốc B",
                phoneNumber: "0973360262",
                createDate: Date().timeIntervalSince1970 - 2.day,
                imageID: ["Image1"]
            )
        ]
        
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
        
    }
    
}

//MARK: PRIVATE METHOD
extension BuildingListViewController {
    func stringFromPastTime(_ time: TimeInterval) -> String {
        let deltaTime = Date().timeIntervalSince1970 - time
        
        guard deltaTime > 1.day else {
            return Utility.shared.stringFromPastTimeToText(time)
        }
        
        if deltaTime < 2.day {
            return timeFormatter.string(from: Date(timeIntervalSince1970: time)) + " hôm qua"
        } else {
            return dateTimeFormatter.string(from: Date(timeIntervalSince1970: time))
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
        
        cell.textLabel?.text = building.name
        cell.detailTextLabel?.text = Utility.shared.split(longString: building.address, maxCharacter: 40)
        
        cell.labelTime.text = stringFromPastTime(building.createDate)
        cell.imageView?.image = UIImage.Asset.empty.image
        
        if let realmImage = DatabaseSupport.shared.getImageOf(buildingID: building.buildingID).last {
            let syncImage = realmImage.convertToSyncType()
            if let thumbnail = syncImage.image {
                cell.imageView?.image = thumbnail
            }
        }
                
    }
}

// MARK: TABLE DELEGATE
extension BuildingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
    
}
