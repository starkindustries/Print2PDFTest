//
//  MainTableViewController.swift
//  Print2PDF
//
//  Created by Zion Perez on 11/29/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let basicCellId: String = "BasicDisclosureCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: basicCellId)
        self.title = "Print2PDF Test"
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: basicCellId, for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        // Configure the cell...
        if indexPath.row == 0 {
            cell.textLabel?.text = "Delay PDF Export (UIWebView)"
        } else if indexPath.row == 1{
            cell.textLabel?.text = "Export PDF Immediately (UIWebView)"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Testing Using WKWebView"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL SELECTED: \(indexPath.description)")
        if indexPath.row == 0 {
            let preview = PreviewViewController()
            preview.exportImmediately = false
            preview.title = "Delay PDF Export"
            self.navigationController?.pushViewController(preview, animated: true)
        } else if indexPath.row == 1 {
            let preview = PreviewViewController()
            preview.exportImmediately = true
            preview.title = "Export PDF Immediately"
            self.navigationController?.pushViewController(preview, animated: true)
        } else if indexPath.row == 2 {
            let wkVC = WebKitViewController()
            wkVC.title = "WKWebView"
            self.navigationController?.pushViewController(wkVC, animated: true)
        }
    }
}
