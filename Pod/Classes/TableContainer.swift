//
//  SideMenuTableController.swift
//  Sweedate
//
//  Created by VLADIMIR KONEV on 29.01.16.
//  Copyright © 2016 Sweedate. All rights reserved.
//

import UIKit

public class TableContainer: AbstractContainer{
    
    @IBOutlet var tableView: UITableView!
    
    public static let defaultCellID: String = "SideMenuCellID"
    
    override public func viewDidLoad() {
        // Set toggle properties before super to avoid double call for show menu animation
        toggleAnimationType = .SlideAbove
        toggleOffsetConstant = 250.0
        super.viewDidLoad()
        
        // Check table existence
        if tableView == nil{
            tableView = UITableView(frame: container.frame, style: .Plain)
            tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            container.addSubview(tableView!)
        }
        
        // Check default cell_id registered
        if tableView.dequeueReusableCellWithIdentifier(TableContainer.defaultCellID) == nil{
            tableView.registerClass(TableMenuCell.self, forCellReuseIdentifier: TableContainer.defaultCellID)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public override func addMenuItem(item: MenuItem) {
        super.addMenuItem(item)
        tableView.reloadData()
    }
    
    public override func removeAllItems() {
        super.removeAllItems()
        tableView.reloadData()
    }
}

// MARK: Implement data source
extension TableContainer: UITableViewDataSource{
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableContainer.defaultCellID, forIndexPath: indexPath)
        
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let menuCell = cell as? TableMenuCell else{
            return
        }
        
        menuCell.item = menuItems[indexPath.row]
    }
}

extension TableContainer: UITableViewDelegate{
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let menuCell = tableView.cellForRowAtIndexPath(indexPath) as? TableMenuCell, item = menuCell.item else{
            return
        }
        
        if let content = item.content{
            pushController(content)
        }else if let segueId = item.segueIdentifier{
            performSegueWithIdentifier(segueId, sender: item)
        }
    }
}

