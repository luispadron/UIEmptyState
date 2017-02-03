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
        static var emptyStateDataSource = "com.luispadron.emptyStateDataSource"
        static var emptyStateDelegate = "com.luispadron.emptyStateDelegate"
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
    
    public weak var emptyStateDelegate: UIEmptyStateDelegate? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDelegate) as? UIEmptyStateDelegate }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDelegate, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// The empty state view associated to the tableViewController
    public var emptyStateView: UIView? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN)
            // Set the views delegate
            if let view = emptyStateView as? UIEmptyStateView { view.delegate = emptyStateDelegate }
        }
    }
    
    public func reloadTableViewEmptyState() {
        guard let source = emptyStateDataSource, source.shouldShowEmptyStateView(forTableView: self.tableView) else {
            if let presentedView = emptyStateView {
                // Show the view and allow scrolling again
                presentedView.isHidden = true
                self.tableView.isScrollEnabled = true
            }
            return
        }
        
        // Check whether we allow scrolling or not
        self.tableView.isScrollEnabled = source.emptyStateViewAllowsScrolling()
        // Toggle or create the view if not created yet
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
        }
    }
    
}

