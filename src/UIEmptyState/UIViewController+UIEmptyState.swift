//
//  UIViewController+UIEmptyState
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

/// Extension on UIViewController which adds method and computed properties in order to allow empty view creation
extension UIViewController {
    /// Private struct of keys to be used with objective-c associated objects
    private struct Keys {
        static var emptyStateView = "com.luispadron.emptyStateView"
        static var emptyStateDataSource = "com.luispadron.emptyStateDataSource"
        static var emptyStateDelegate = "com.luispadron.emptyStateDelegate"
    }
    
    /**
     The data source for the Empty View
     
     Default conformance for UIViewController is provided,
     however feel free to implement these methods to customize your view.
     */
    public var emptyStateDataSource: UIEmptyStateDataSource? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDataSource)  as? UIEmptyStateDataSource }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDataSource, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /**
     The delegate for UIEmptyStateView
     
     **Important:** this delegate and its functions are only used when using UIEmptyStateView.
     If you will provide a custom view in the UIEmptyStateDataSource you must handle how this delegate operates
     */
    public var emptyStateDelegate: UIEmptyStateDelegate? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDelegate) as? UIEmptyStateDelegate }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /**
     The empty state view associated to the ViewController
     
     **Note:**
     This view corresponds and is created from
     the UIEmptyDataSource method: `func viewForEmptyState() -> UIView`

     To set this view, use `UIEmptyStateDataSource.emptyStateView`.
     
     By default this view is of type `UIEmptyStateView`
     */
    private var emptyView: UIView? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // Set the views delegate
            if let view = emptyView as? UIEmptyStateView { view.delegate = emptyStateDelegate }
        }
    }
    
    /**
     The method responsible for show and hiding the `UIEmptyStateDataSource.viewForEmptyState` view
     
     **Important:**
     This should be called whenever changes are made to the tableView data source or after reloading the tableview
     
     Do NOT override this method/implement it unless you need custom behavior and know what you are doing.
     */
    public func reloadEmptyStateForTableView(_ tableView: UITableView) {
        guard let source = emptyStateDataSource, source.emptyStateViewShouldShow(for: tableView) else {
            // Call the will hide delegate
            if let view = emptyView {
                self.emptyStateDelegate?.emptyStateViewWillHide(view: view)
            }
            // If shouldnt show view remove from superview, enable scrolling again
            emptyView?.isHidden = true
            tableView.isScrollEnabled = true
            // Also return edges for extended layout to the default values, if adjusted
            if emptyStateDataSource?.emptyStateViewAdjustsToFitBars ?? false {
                self.edgesForExtendedLayout = .all
            }
            return
        }
        
        // Check whether scrolling for tableview is allowed or not
        tableView.isScrollEnabled = source.emptyStateViewCanScroll
        
        finishReload(for: source, in: tableView)
    }
    
    /**
     The method responsible for show and hiding the `UIEmptyStateDataSource.viewForEmptyState` view
     
     **Important:**
     This should be called whenever changes are made to the collection view data source or after reloading the collection view.
     
     Do NOT override this method/implement it unless you need custom behavior and know what you are doing.
     */
    public func reloadEmptyStateForCollectionView(_ collectionView: UICollectionView) {
        guard let source = emptyStateDataSource,
            source.emptyStateViewShouldShow(for: collectionView) else {
                // Call the will hide delegate
                if let view = emptyView {
                    self.emptyStateDelegate?.emptyStateViewWillHide(view: view)
                }
                // If shouldnt show view remove from superview, enable scrolling again
                emptyView?.isHidden = true
                collectionView.isScrollEnabled = true
                // Also return edges for extended layout to the default values, if adjusted
                if emptyStateDataSource?.emptyStateViewAdjustsToFitBars ?? false {
                    self.edgesForExtendedLayout = .all
                }
                return
        }
        
        // Check to see if scrolling is enabled
        collectionView.isScrollEnabled = source.emptyStateViewCanScroll
        
        finishReload(for: source, in: collectionView)
        
    }
    
    /// Finishes the reload, i.e assigns the empty view, and adjusts any other UI
    private func finishReload(for source: UIEmptyStateDataSource, in superView: UIView) {
        let emptyView = showView(for: source, in: superView)

        // Only add constraints if they haven't already been added
        if emptyView.constraints.count <= 2 { // 2, because theres already 2 constraints added to it's subviews
            self.createViewConstraints(for: emptyView, in: superView, source: source)
        }

        // Return & call the did show view delegate
        self.emptyStateDelegate?.emptyStateViewDidShow(view: emptyView)
    }

    //// Private helper which creates view contraints for the UIEmptyStateView.
    private func createViewConstraints(for view: UIView, in superView: UIView, source: UIEmptyStateDataSource) {

        var centerYOffset: CGFloat?
        // Takes into account any extra offset that the table's header view might need, this way
        // we get a true center alignment with the table view.
        if let tableHeader = (superView as? UITableView)?.tableHeaderView {
            centerYOffset = tableHeader.frame.height / 2.0
        }

        var centerY = view.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        var centerX = view.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: centerYOffset ?? 0)
        centerX.isActive = true
        centerY.isActive = true

        // If iOS 11.0 is not available, then adjust the extended layout accordingly using older API
        // and then return
        guard #available(iOS 11.0, *) else {
            // Adjust to fit bars if allowed
            if source.emptyStateViewAdjustsToFitBars {
                self.edgesForExtendedLayout = []
            } else {
                self.edgesForExtendedLayout = .all
            }
            return
        }

        // iOS 11.0+ is available, thus use new safeAreaLayoutGuide, but only if adjustesToFitBars is true.
        // The reason for this is safeAreaLayoutGuide will take into account any bar that may be used
        // If for some reason user doesn't want to adjust to bars, then keep the old center constraints
        if source.emptyStateViewAdjustsToFitBars {
            // Adjust constraint to fit new big title bars, etc
            centerX.isActive = false
            centerX = view.centerXAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerXAnchor)
            centerX.isActive = true

            centerY.isActive = false
            centerY = view.centerYAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerYAnchor,
                                                    constant: centerYOffset ?? 0)
            centerY.isActive = true

        }
    }

    /// Private helper method which will create the empty state view if not created, or show it if hidden
    private func showView(for source: UIEmptyStateDataSource, in view: UIView) -> UIView {
    
        if let createdView = emptyView {
            // Call the will show delegate
            self.emptyStateDelegate?.emptyStateViewWillShow(view: createdView)
            // View has been created, update it and then reshow
            createdView.isHidden = false
            guard let view = createdView as? UIEmptyStateView else { return createdView }
            
            view.backgroundColor = source.emptyStateBackgroundColor
            view.title = source.emptyStateTitle
            view.image = source.emptyStateImage
            view.imageSize = source.emptyStateImageSize
            view.imageViewTintColor = source.emptyStateImageViewTintColor
            view.buttonTitle = source.emptyStateButtonTitle
            view.buttonImage = source.emptyStateButtonImage
            view.buttonSize = source.emptyStateButtonSize
            view.detailMessage = source.emptyStateDetailMessage
            view.spacing = source.emptyStateViewSpacing
            view.centerYOffset = source.emptyStateViewCenterYOffset
            view.backgroundColor = source.emptyStateBackgroundColor
            
            // Animate now
            if source.emptyStateViewCanAnimate && source.emptyStateViewAnimatesEverytime {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(
                        for: view,
                        animationDuration: source.emptyStateViewAnimationDuration,
                        completion: { finished in
                            self.emptyStateDelegate?.emptyStateViewAnimationCompleted(for: view, didFinish: finished)
                        }
                    )
                }
            }
            
            return view
            
        } else {
            // We can create the view now
            let newView = source.emptyStateView
            // Call the will show delegate
            self.emptyStateDelegate?.emptyStateViewWillShow(view: newView)
            // Add to emptyStateView property
            emptyView = newView
            // Add as a subView, bring it infront of the tableView
            view.addSubview(newView)
            view.bringSubviewToFront(newView)
            // Animate now
            if source.emptyStateViewCanAnimate {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(
                        for: newView,
                        animationDuration: source.emptyStateViewAnimationDuration,
                        completion: { finished in
                            self.emptyStateDelegate?.emptyStateViewAnimationCompleted(for: newView, didFinish: finished)
                        }
                    )
                }
            }
            
            return newView
        }
    }
    
}

/// A convenience extension for UITableViewController which defaults the tableView
extension UITableViewController {
    /// Reloads the empty state, defaults the tableView to `self.tableView`
    public func reloadEmptyState() {
        self.reloadEmptyStateForTableView(self.tableView)
    }
}

/// A convenience extension for UICollectionViewController which defaults the collectionView
extension UICollectionViewController {
    /// Reloads the empty state, defaults the collectionView to `self.collectionView`
    public func reloadEmptyState() {
        guard let collectionView = self.collectionView else {
            print("UIEmptyState ==== WARNING: Tried to reload collectionView's empty state but the collectionView for\n\(self) was nil.")
            return
        }
        
        self.reloadEmptyStateForCollectionView(collectionView)
    }
}



