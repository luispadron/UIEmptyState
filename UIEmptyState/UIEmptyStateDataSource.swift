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
    
    /**
     Determines whether should or should not show the empty view for a specific tableView,
     by default it will count tableView rows to determine
     
     - paramaters:
         - tableView: The tableview which the emptyStateView will display over
     - returns:
         Boolean value of whether view should or should not be displayed
     */
    func emptyStateViewShouldShow(for tableView: UITableView) -> Bool
    
    /**
     Determines whether should or should not show the empty view for a specific collectionView,
     by default it will count collectionView items to determine
 
     - paramaters:
         - collectionView: The collectionView which the emptyStateView will display over
     - returns:
         Boolean value of whether view should or should not be displayed
     */
    func emptyStateViewShouldShow(for collectionView: UICollectionView) -> Bool
    
    /**
     Determines the view to use for the empty state, by default this is a nice stack view
 
     **Important:** By default this will return a UIEmptyStateView, implementing this method will
     cause the delegation of button and view touches to no longer work,
     unless you implement those yourself as well.
     */
    var emptyStateView: UIView { get }
    
    /**
     Determines whether the `emptyStateView` should adjust to be shown properly inside by
     not extending the view past the navigation bar and tab bar of a navigation controller.
     */
    var emptyStateViewAdjustsToFitBars: Bool { get }
    
    /**
     Determines the title for the Empty View, by default this just returns an intro message,
     override for custom title
     */
    var emptyStateTitle: NSAttributedString { get }
    
    /**
     Determines the image which will be used inside the Empty State View's image view, default value is nil
     */
    var emptyStateImage: UIImage? { get }
    
    /**
     Determines the size of the image view, by default this will return nil which means
     that the imageview size will just be 100x100
     */
    var emptyStateImageSize: CGSize? { get }
    
    /**
     Determines the title for the button of the Empty State View, by default this is nil
     */
    var emptyStateButtonTitle: NSAttributedString? { get }
    
    /**
     Determines the image for the button, by default this will return nil
     */
    var emptyStateButtonImage: UIImage? { get }
    
    /**
     Determines the size of the button, by default it will constrain the view to the size
     of the title plus some padding.
     
     Implement this method to send a custom size for the button,
     useful when adding a buttonImage to the button
     */
    var emptyStateButtonSize: CGSize? { get }
    
    /**
     Determines the message which will be displayed in the detail view of the empty state view,
     by default this will return an intro message
     */
    var emptyStateDetailMessage: NSAttributedString? { get }
    
    /// Determines the amount of spacing between the views, by default this is 12
    var emptyStateViewSpacing: CGFloat { get }
    
    /// Determines the background color for the emptyStateView, by default this value is UIColor.clear
    var emptyStateBackgroundColor: UIColor { get }
    
    /**
     Whether the empty state view allows scrolling or not, by default this is false
 
     **Note:** This is only called when view is displayed, if not displayed scrolling will be enabled for the table view
     */
    var emptyStateViewCanScroll: Bool { get }
    
    /**
     Whether the empty state view should animate or not
 
     **Note:**
     This is called whenever the empty state view will show, if false; no animation will occur. Default = true
     */
    var emptyStateViewCanAnimate: Bool { get }
    
    /**
     Whether the empty state view animates every time it is shown
    
     **Note:**
     This is called whenever the empty state view will show, returning true means that an animation
     from `emptyStateViewAnimation` will be performed everytime the view is shown
     returning false means that only the inital animation is shown.
     To turn off animation in general use `emptyStateViewCanAnimate`
    */
    var emptyStateViewAnimatesEverytime: Bool { get }
    
    /**
     The amount of time the empty state view should animate for
 
     **Note:**
     This is called whenever the empty state view will show, Default = 0.5
     */
    var emptyStateViewAnimationDuration: TimeInterval { get }
    
    /**
     The animation function for the views in the empty state view
 
     ***Note:*** This is called whenever the empty state view will show, Default = pop in and fade in of views
 
     - Parameters:
         - view: The view which will be animated, can be used to control its properties inside a `UIView.animate` block
     
         - animationDuration: The duration which we should animate for,
                              value is grabbed from `emptyStateViewAnimationDuration`
     
         - completion: The completion block for the emptyStateView,
                       if implementing this pass this to the `UIView.animate` completion block
                       in order for the delegate to work properly
     */
    func emptyStateViewAnimation(for view: UIView, animationDuration: TimeInterval,
                                 completion: ((Bool) -> Void)?) -> Void
}

/// Extension for the UIEmptyDataSource which adds a default implementation for any UIViewController Subclass
extension UIEmptyStateDataSource where Self: UIViewController {
    
    /**
     Default implementation for UIViewController tableView determining if should show the emptystate view,
     counts number of rows in the tableView
     */
    public func emptyStateViewShouldShow(for tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        var rows = 0
        for section in 0..<sections {
            rows += tableView.numberOfRows(inSection: section)
        }
        return rows == 0
    }
    
    /**
     Default implementation for UIViewController collectionView determining if should show the emptystate view,
     counts number of items in the collectionView
     */
    public func emptyStateViewShouldShow(for collectionView: UICollectionView) -> Bool {
        let sections = collectionView.numberOfSections
        var items = 0
        for section in 0..<sections {
            items += collectionView.numberOfItems(inSection: section)
        }
        return items == 0
    }
    
    /// Default implementation of `emptystateView` returns a `UIEmptyStateView`
    public var emptyStateView: UIView {
        get {
            let emptyStateView = UIEmptyStateView(frame: self.view.frame, title: emptyStateTitle)
            // Call and assign the data source methods
            emptyStateView.image = emptyStateImage
            emptyStateView.imageSize = emptyStateImageSize
            emptyStateView.buttonTitle = emptyStateButtonTitle
            emptyStateView.buttonImage = emptyStateButtonImage
            emptyStateView.buttonSize = emptyStateButtonSize
            emptyStateView.detailMessage = emptyStateDetailMessage
            emptyStateView.spacing = emptyStateViewSpacing
            emptyStateView.backgroundColor = emptyStateBackgroundColor
            // Some auto resize constraints
            emptyStateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return emptyStateView
        }
    }
    
    /// Default implementation of `emptyStateViewAdjustsToFitBars` returns `true`
    public var emptyStateViewAdjustsToFitBars: Bool { get { return true } }
    
    /// Default implementation of `emptyStateTitle`, returns an intro title
    public var emptyStateTitle: NSAttributedString { get { return NSAttributedString(string: "UIEmptyState") } }
    
    /// Default implementation of `emptyStateImage`, returns nil
    public var emptyStateImage: UIImage? { get { return nil } }
    
    /// Default implementation of `emptyStateImageSize`, returns nil
    public var emptyStateImageSize: CGSize? { get { return nil } }
    
    /// Default implementation of `emptyStateButtonTitle`, returns nil
    public var emptyStateButtonTitle: NSAttributedString? { get { return nil } }
    
    /// Default implementation of `emptyStateButtonImage`, returns nil
    public var emptyStateButtonImage: UIImage? { get { return nil } }
    
    /// Default implementation of `emptyStateButtonSize`, returns nil,
    /// thus size will be calculated using size of `buttonTitle`
    public var emptyStateButtonSize: CGSize? { get { return nil } }
    
    /// Default implementation of `emptyStateDetailMessage`, returns nil
    public var emptyStateDetailMessage: NSAttributedString? { get { return nil } }
    
    /// Default implementation of `emptyStateViewSpacing`, returns 12
    public var emptyStateViewSpacing: CGFloat { get { return 12 } }
    
    /// Default implementation of `emptyStateBackgroundColor`, returns `UIColor.clear`
    public var emptyStateBackgroundColor: UIColor { get { return .clear } }
    
    /// Default implementation of `emptyStateViewCanScroll`, returns `false`
    public var emptyStateViewCanScroll: Bool { get { return false } }
    
    /// Default implementation of `emptyStateViewCanAnimate`, returns `true`
    public var emptyStateViewCanAnimate: Bool { get { return true } }
    
    /// Default implementation of `emptyStateViewAnimatesEverytime`, returns `false`
    public var emptyStateViewAnimatesEverytime: Bool { get { return false } }
    
    /// Default implementation of `emptyStateViewAnimationDuration`, returns `0.5`
    public var emptyStateViewAnimationDuration: TimeInterval { get { return 0.5 } }
    
    /// Default implementation of `emptyStateViewAnimation`, implements a simple animation
    public func emptyStateViewAnimation(for view: UIView, animationDuration: TimeInterval,
                                        completion: ((Bool) -> Void)?) -> Void {
        guard let v = view as? UIEmptyStateView else { return }
        // Set initial alpha
        v.imageView.alpha = 0.0
        v.titleLabel.alpha = 0.0
        v.detailLabel.alpha = 0.0
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
                v.titleLabel.alpha = 1.0
                v.detailLabel.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                v.button.alpha = 1.0
                v.button.transform = CGAffineTransform.identity
            })
            
        }, completion: completion)
        
    }
}
