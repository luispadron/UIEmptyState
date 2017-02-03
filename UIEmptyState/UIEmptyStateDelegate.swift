//
//  UIEmptyStateDelegate.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

public protocol UIEmptyStateDelegate: class {
    /// The call back for when the button inside the emptyStateView is tapped
    func emptyStatebuttonWasTapped(button: UIButton)
    /// The call back for when the emptyStateView itself is tapped
    func emptyStateViewWasTapped(view: UIView)
}

extension UIEmptyStateDelegate where Self: UITableViewController {
    public func emptyStatebuttonWasTapped(button: UIButton) { }
    public func emptyStateViewWasTapped(view: UIView) { }
}
