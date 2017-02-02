//
//  UIEmptyStateDataSource.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//


/// The data source for the Empty View
public protocol UIEmptyStateDataSource: class {
    /// Determines whether should or should not show the empty view, by default it will count tableView rows to determine
    func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool
    /// Determines the view to use for the empty state, by default this is a nice stack view
    func viewForEmptyState() -> UIView
    /// Determines the title for the Empty View, by default this just returns "I'm a Title", override for custom title
    func titleForEmptyStateView() -> NSAttributedString
    /// Determines the image which will be used inside the Empty State View's image view
    func imageForEmptyStateView() -> UIImage?
    /// Determines the title for the button of the Empty State View
    func buttonTitleForEmptyStateView() -> NSAttributedString?
    /// Determines the image for the button
    func buttonImageForEmptyStateView() -> UIImage?
    /// Determines the message which will be displayed in the detail view
    func detailMessageForEmptyStateView() -> NSAttributedString?
    /// Determines the amount of spacing between the views
    func spacingForViewsInEmptyStateView() -> CGFloat
    /// Determines the background color for the emptyStateView 
    func backgroundColorForEmptyStateView() -> UIColor
}

/// Extension for the UIEmptyDataSource which adds a default implementation for any UITableViewController
extension UIEmptyStateDataSource where Self: UITableViewController {
    public func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        var rows = 0
        for section in 0..<sections {
            rows += tableView.numberOfRows(inSection: section)
        }
        return rows == 0
    }
    
    public func viewForEmptyState() -> UIView {
        let emptyStateView = UIEmptyStateView(frame: self.view.frame, title: titleForEmptyStateView())
        // Call and assign the data source methods
        emptyStateView.backgroundColor = backgroundColorForEmptyStateView()
        emptyStateView.image = imageForEmptyStateView()
        emptyStateView.detailMessage = detailMessageForEmptyStateView()
        emptyStateView.buttonTitle = buttonTitleForEmptyStateView()
        emptyStateView.buttonImage = buttonImageForEmptyStateView()
        emptyStateView.spacing = spacingForViewsInEmptyStateView()
        // Some auto resize constraints
        emptyStateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return emptyStateView
    }
    
    public func titleForEmptyStateView() -> NSAttributedString {
        return NSAttributedString(string: "UIEmptyState", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
    }
    
    public func imageForEmptyStateView() -> UIImage? {
        return nil
    }
    
    public func buttonTitleForEmptyStateView() -> NSAttributedString? {
        return nil
    }
    
    public func buttonImageForEmptyStateView() -> UIImage? {
        return nil
    }
    
    public func detailMessageForEmptyStateView() -> NSAttributedString? {
        return NSAttributedString(string: "Implement the UIEmptyStateDataSource methods to change me.\nThanks for using this library!",
                                  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
    }
    
    public func spacingForViewsInEmptyStateView() -> CGFloat {
        return 12
    }
    
    public func backgroundColorForEmptyStateView() -> UIColor {
        return UIColor.clear
    }
}
