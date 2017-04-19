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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        building = DatabaseSupport.shared.getAllBuildings().map { $0.convertToSyncType() }

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

extension BuildingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return building.count
    }
}

extension BuildingListViewController: UITableViewDelegate {
    
}

extension BuildingListViewController {
    func setupAllSubview() {
        
    }
    
    func setupAllConstraints() {
        
    }
    
}





















