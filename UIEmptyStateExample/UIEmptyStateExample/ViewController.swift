//
//  ViewController.swift
//  UIEmptyStateExample
//
//  Created by Luis Padron on 2/3/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit
import UIEmptyState

class EmptyStateTableViewController: UITableViewController, UIEmptyStateDelegate, UIEmptyStateDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Email App"
        // Set the data source and delegate to self
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - Empty State
    
    // MARK: - TableView delegation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell")!
        cell.textLabel?.text = "Example cell"
        return cell
    }


}

