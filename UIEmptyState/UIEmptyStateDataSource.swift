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
    
    /// Whether the empty state view should animate or not
    ///
    /// **Note:** This is called whenever the empty state view will show, if false; no animation will occur. Default = true
    /// - returns:
    ///     Bool a boolean value which determines if the view should or shouldn't animate
    func emptyStateViewCanAnimate() -> Bool
    
    /// Whether the empty state view animates every time it is shown
    ///
    /// **Note:** This is called whenever the empty state view will show, returning true means that an animation from `emptyStateViewAnimation` will be performed everytime the view is shown
    ///           returning false means that only the inital animation is shown. To turn off animation in general use `emptyStateViewCanAnimate`
    /// - returns:
    ///     Bool a boolean value which determines if the view should animate only initially
    func emptyStateViewPerformsAnimationEveryTime() -> Bool
    
    /// The amount of time the empty state view should animate for
    ///
    /// **Note:** This is called whenever the empty state view will show, Default = 0.5
    /// - returns:
    ///     TimeInterval the time for the animation to last
    func emptyStateViewAnimationDuration() -> TimeInterval
    
    /// The animation function for the views in the empty state view
    ///
    /// ***Note:*** This is called whenever the empty state view will show, Default = pop in and fade in of views
    /// - paramters:
    ///     - view: The view which will be animated, can be used to control its properties inside a `UIView.animate` block
    ///     - animationDuration: The duration which we should animate for, value is grabbed from `emptyStateViewAnimationDuration`
    ///     - completion: The completion block for the emptyStateView, if implementing this pass this to the `UIView.animate` completion block in order for the delegate to work properly
    func emptyStateViewAnimation(forView view: UIView, animationDuration: TimeInterval, completion: ((Bool) -> Void)?) -> Void
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
    
    /// Default implementation of `detailMessageForEmptyStateView`, returns nil
    public func detailMessageForEmptyStateView() -> NSAttributedString? {
        return nil
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
    
    /// Default implementation of `emptyStateViewCanAnimate`, returns `true`
    public func emptyStateViewCanAnimate() -> Bool {
        return true
    }
    
    /// Default implementation of `emptyStateViewPerformsAnimationEveryTime`, returns `true`
    public func emptyStateViewPerformsAnimationEveryTime() -> Bool {
        return true
    }
    
    /// Default implementation of `emptyStateViewAnimationDuration`, returns `0.5`
    public func emptyStateViewAnimationDuration() -> TimeInterval {
        return 0.5
    }
    
    /// Default implementation of `emptyStateViewAnimation`, implements a simple animation
    public func emptyStateViewAnimation(forView view: UIView, animationDuration: TimeInterval, completion: ((Bool) -> Void)?) -> Void {
        guard let v = view as? UIEmptyStateView else { return }
        // Set initial alpha
        v.imageView.alpha = 0.0
        v.titleView.alpha = 0.0
        v.detailView.alpha = 0.0
        v.button.alpha = 0.0
        // Set initial scale to 0
        v.imageView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        v.button.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)

        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [], animations: { 
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                v.imageView.alpha = 1.0
                v.imageView.transform = CGAffineTransform.identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                v.titleView.alpha = 1.0
                v.detailView.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                v.button.alpha = 1.0
                v.button.transform = CGAffineTransform.identity
            })
            
        }, completion: completion)
        
    }
}
