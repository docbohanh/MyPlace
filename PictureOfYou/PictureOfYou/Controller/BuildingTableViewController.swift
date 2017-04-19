//
//  BuildingTableViewController.swift
//  PictureOfYou
//
//  Created by Thành Lã on 4/18/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

public class BuildingTableViewController: PTTableViewController {
    
    fileprivate let items: [(name: String, title: String)] = [
        ("1", "River cruise"),
        ("2", "North Island"),
        ("3", "Mountain trail"),
        ("4", "Southern Coast"),
        ("5", "Fishing place")
    ] // image names
}

// MARK: UITableViewDelegate
extension BuildingTableViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ParallaxCell else { return }
        
        let index = indexPath.row % items.count
        let imageName = items[index].name
        let title = items[index].title
        
        if let image = UIImage(named: imageName) {
            cell.setImage(image, title: title)
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ParallaxCell = tableView.getReusableCellWithIdentifier(indexPath: indexPath)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.storyboard(storyboard: .Main)
        let detaleViewController: DetailViewController = storyboard.instantiateViewController()
        pushViewController(detaleViewController)
    }
    
}





















