//
//  UIEmptyState.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//


public protocol UIEmptyStateDataSource: class {
    func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool
}


extension UIEmptyStateDataSource where Self: UITableViewController {
    public func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        var rows = 0
        for section in 0..<sections {
            rows += tableView.numberOfRows(inSection: section)
        }
        return rows == 0
    }
}


extension UITableViewController {
    private struct Keys {
        static var emptyStateDataSource = "com.luispadron.emptyStateDelegate"
    }
    
    public weak var emptyStateDataSource: UIEmptyStateDataSource? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDataSource)  as? UIEmptyStateDataSource }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateDataSource, newValue, .OBJC_ASSOCIATION_RETAIN)
            // Reload after setting
            reloadTableViewEmptyState()
        }
    }
    
    public func reloadTableViewEmptyState() {
        guard let source = emptyStateDataSource, source.shouldShowEmptyStateView(forTableView: self.tableView) else {
            return
        }
        
        print("Should show")
    }
}
