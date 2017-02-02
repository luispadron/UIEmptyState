//
//  UITableViewController+UIEmptyState.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

/// Extension on UITableViewController which adds method and computed properties in order to allow empty view creation
extension UITableViewController {
    /// Private struct of keys to be used with objective-c associated objects
    private struct Keys {
        static var emptyStateView = "com.luispadron.emptyStateView"
        static var emptyStateDataSource = "com.luispadron.emptyStateDelegate"
    }
    
    /// The data source for the Empty View
    public weak var emptyStateDataSource: UIEmptyStateDataSource? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDataSource)  as? UIEmptyStateDataSource }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateDataSource, newValue, .OBJC_ASSOCIATION_RETAIN)
            // Reload after setting
            reloadTableViewEmptyState()
        }
    }
    
    /// The empty state view associated to the tableViewController
    public var emptyStateView: UIView? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateView) as? UIView }
        set { objc_setAssociatedObject(self, &Keys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    public func reloadTableViewEmptyState() {
        guard let source = emptyStateDataSource, source.shouldShowEmptyStateView(forTableView: self.tableView) else {
            if let presentedView = emptyStateView { presentedView.isHidden = true }
            return
        }
        
        
        if let createdView = emptyStateView {
            // View was already created we can go ahead and just show it again
            createdView.isHidden = false
        } else {
            // We can create the view now
            let newView = source.viewForEmptyState()
            newView.frame = self.view.bounds
            // Add to emptyStateView property
            emptyStateView = newView
            // Add as a subView, bring it infront of the tableView
            self.view.addSubview(newView)
            self.view.bringSubview(toFront: newView)
            // Add center constraints
            newView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            newView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
    }
    
}

