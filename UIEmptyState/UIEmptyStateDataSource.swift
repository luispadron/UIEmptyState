//
//  UIEmptyStateDataSource.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//


/// The data source for the Empty View
///
/// Default conformance for UIViewContoller is provided,
/// however feel free to implement these methods to customize your view.
public protocol UIEmptyStateDataSource: class {

    /// Determines whether should or should not show the empty view for a specific tableView, by default it will count tableView rows to determine
    ///
    /// - paramaters:
    ///     - tableView: The tableview which the emptyStateView will display over
    /// - returns: 
    ///     Boolean value of whether view should or should not be displayed
    func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool
    
    /// Determines whether should or should not show the empty view for a specific collectionView, by default it will count collectionView items to determine
    ///
    /// - paramaters:
    ///     - collectionView: The collectionView which the emptyStateView will display over
    /// - returns:
    ///     Boolean value of whether view should or should not be displayed
    func shouldShowEmptyStateView(forCollectionView collectionView: UICollectionView) -> Bool
    
    /// Determines the view to use for the empty state, by default this is a nice stack view
    ///
    /// **Important:** By default this will return a UIEmptyStateView, implementing this method will
    /// cause the delegation of button and view touches to no longer work, unless you implement those yourself as well.
    func viewForEmptyState() -> UIView
    
    /// Determines the title for the Empty View, by default this just returns an intro message, override for custom title
    /// - returns:
    ///     NSAttributedString which will be set to the titles label
    func titleForEmptyStateView() -> NSAttributedString
    
    /// Determines the image which will be used inside the Empty State View's image view, default value is nil
    /// - returns:
    ///     UImage? optional image, if nil, image view will not be displayed
    func imageForEmptyStateView() -> UIImage?
    
    /// Determines the size of the image view, by default this will return nil which means that the imageview size will just be 100x100
    /// - returns: 
    ///     CGSize? optional size for image view
    func imageSizeForEmptyStateView() -> CGSize?
    
    /// Determines the title for the button of the Empty State View, by default this is nil
    /// - returns:
    ///     NSAttributedString? optinal attributed string which will be set to the buttons title for the normal state, if nil, no button will be displayed
    func buttonTitleForEmptyStateView() -> NSAttributedString?
    
    /// Determines the image for the button, by default this will return nil
    /// - returns:
    ///     UIImage? optional image for the buttons .backgroundImage
    func buttonImageForEmptyStateView() -> UIImage?
    
    /// Determines the size of the button, by default it will constrain the view to the size of the title plus some padding.
    /// Implement this method to send a custom size for the button, useful when adding a buttonImage to the button
    /// - returns:
    ///     CGSize? optional size for the button
    func buttonSizeForEmptyStateView() -> CGSize?
    
    /// Determines the message which will be displayed in the detail view of the empty state view, by default this will return an intro message
    /// - returns:
    ///     NSAttributedString? optional attributed message to be displayed in a label under the title view
    func detailMessageForEmptyStateView() -> NSAttributedString?
    
    /// Determines the amount of spacing between the views, by default this is 12
    /// - returns: 
    ///     CGFloat the spacing amount between each view in the empty state view's stack view
    func spacingForViewsInEmptyStateView() -> CGFloat
    
    /// Determines the background color for the emptyStateView, by default this value is UIColor.clear
    /// - returns: 
    ///     UIColor the color for the empty state views background color
    func backgroundColorForEmptyStateView() -> UIColor
    
    /// Whether the empty state view allows scrolling or not, by default this is false
    ///
    /// **Note:** This is only called when view is displayed, if not displayed scrolling will be enabled for the table view
    /// - returns:
    ///     Bool a boolean value which will determine if the empty state view allows scrolling
    func emptyStateViewAllowsScrolling() -> Bool
}

/// Extension for the UIEmptyDataSource which adds a default implementation for any UIViewController Subclass
extension UIEmptyStateDataSource where Self: UIViewController {
    /// Default implementation for UIViewController tableView determining if should show the emptystate view, counts number of rows in the tableView
    public func shouldShowEmptyStateView(forTableView tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        var rows = 0
        for section in 0..<sections {
            rows += tableView.numberOfRows(inSection: section)
        }
        return rows == 0
    }
    
    /// Default implementation for UIViewController collectionView determining if should show the emptystate view, counts number of items in the collectionView
    public func shouldShowEmptyStateView(forCollectionView collectionView: UICollectionView) -> Bool {
        let sections = collectionView.numberOfSections
        var items = 0
        for section in 0..<sections {
            items += collectionView.numberOfItems(inSection: section)
        }
        return items == 0
    }
    
    /// Default implementation of `viewForEmptyState`, returns a UIEmptyStateView
    public func viewForEmptyState() -> UIView {
        let emptyStateView = UIEmptyStateView(frame: self.view.frame, title: titleForEmptyStateView())
        // Call and assign the data source methods
        emptyStateView.backgroundColor = backgroundColorForEmptyStateView()
        emptyStateView.image = imageForEmptyStateView()
        emptyStateView.imageSize = imageSizeForEmptyStateView()
        emptyStateView.detailMessage = detailMessageForEmptyStateView()
        emptyStateView.buttonTitle = buttonTitleForEmptyStateView()
        emptyStateView.buttonImage = buttonImageForEmptyStateView()
        emptyStateView.buttonSize = buttonSizeForEmptyStateView()
        emptyStateView.spacing = spacingForViewsInEmptyStateView()
        // Some auto resize constraints
        emptyStateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return emptyStateView
    }
    
    /// Default implementation of `titleForEmptyStateView`, returns an intro title
    public func titleForEmptyStateView() -> NSAttributedString {
        return NSAttributedString(string: "UIEmptyState", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
    }
    
    /// Default implementation of `imageForEmptyStateView`, returns nil
    public func imageForEmptyStateView() -> UIImage? {
        return nil
    }
    
    /// Default implementation of `imageSizeForEmptyStateView`, returns nil
    public func imageSizeForEmptyStateView() -> CGSize? {
        return nil
    }
    
    /// Default implementation of `buttonTitleForEmptyStateView`, returns nil
    public func buttonTitleForEmptyStateView() -> NSAttributedString? {
        return nil
    }
    
    /// Default implementation of `buttonImageForEmptyStateView`, returns nil
    public func buttonImageForEmptyStateView() -> UIImage? {
        return nil
    }
    
    /// Default implementation of `buttonSizeForEmptyStateView`, returns nil, thus size will be calculated using size of `buttonTitle`
    public func buttonSizeForEmptyStateView() -> CGSize? {
        return nil
    }
    
    /// Default implementation of `detailMessageForEmptyStateView`, returns an intro message
    public func detailMessageForEmptyStateView() -> NSAttributedString? {
        return NSAttributedString(string: "Implement the UIEmptyStateDataSource methods to change me." +
                                        "\nThanks for using this library, star me on GitHub!",
                                  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
    }
    
    /// Default implementation of `spacingForViewsInEmptyStateView`, returns 12
    public func spacingForViewsInEmptyStateView() -> CGFloat {
        return 12
    }
    
    /// Default implementation of `backgroundColorForEmptyStateView`, returns `UIColor.clear`
    public func backgroundColorForEmptyStateView() -> UIColor {
        return UIColor.clear
    }
    
    /// Default implementation of `emptyStateViewAllowsScrolling`, returns `false`
    public func emptyStateViewAllowsScrolling() -> Bool {
        return false
    }
}
