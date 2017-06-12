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
    public weak var emptyStateDataSource: UIEmptyStateDataSource? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDataSource)  as? UIEmptyStateDataSource }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDataSource, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    /**
     The delegate for UIEmptyStateView
 
     **Important:** this delegate and its functions are only used when using UIEmptyStateView.
     If you will provide a custom view in the UIEmptyStateDataSource you must handle how this delegate operates
     */
    public weak var emptyStateDelegate: UIEmptyStateDelegate? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateDelegate) as? UIEmptyStateDelegate }
        set { objc_setAssociatedObject(self, &Keys.emptyStateDelegate, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    /**
     The empty state view associated to the ViewController
 
     **Note:**
     This view corresponds and is created from
     the UIEmptyDataSource method: `func viewForEmptyState() -> UIView`
 
     By default this view is of type `UIEmptyStateView`
     */
    public var emptyStateView: UIView? {
        get { return objc_getAssociatedObject(self, &Keys.emptyStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &Keys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN)
            // Set the views delegate
            if let view = emptyStateView as? UIEmptyStateView { view.delegate = emptyStateDelegate }
        }
    }
    
    /**
     The method responsible for show and hiding the `UIEmptyStateDataSource.viewForEmptyState` view
 
     **Important:**
     This should be called whenever changes are made to the tableView data source or after reloading the tableview
 
     DO NOT override this method/implement it unless you need custom behavior.
     */
    public func reloadEmptyState(forTableView tableView: UITableView) {
        guard let source = emptyStateDataSource, source.shouldShowEmptyStateView(forTableView: tableView) else {
            // If shouldnt show view remove from superview, enable scrolling again
            emptyStateView?.isHidden = true
            tableView.isScrollEnabled = true
            return
        }
        
        // Check whether scrolling for tableview is allowed or not
        tableView.isScrollEnabled = source.emptyStateViewCanScroll
        
        finishReload(for: source)
    }
    
    /**
     The method responsible for show and hiding the `UIEmptyStateDataSource.viewForEmptyState` view
 
     **Important:**
     This should be called whenever changes are made to the collectionView data source
     or after reloading the tableview
     */
    public func reloadEmptyState(forCollectionView collectionView: UICollectionView) {
        guard let source = emptyStateDataSource,
            source.shouldShowEmptyStateView(forCollectionView: collectionView) else {
            // If shouldnt show view remove from superview, enable scrolling again
            emptyStateView?.isHidden = true
            collectionView.isScrollEnabled = true
            return
        }
        
        // Check to see if scrolling is enabled
        collectionView.isScrollEnabled = source.emptyStateViewCanScroll
        
        finishReload(for: source)
        
    }
    
    /// Finishes the reload, i.e assigns the empty view, and adjusts any other UI
    private func finishReload(for source: UIEmptyStateDataSource) {
        
        let emptyView = showView(for: source)
        
        // Set constraints
        var centerX = emptyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerX.isActive = true
        var centerY = emptyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
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
            // Call the did show view delegate
            self.emptyStateDelegate?.emptyStateViewDidShow(view: emptyView)
            return
        }
        
        
        // iOS 11.0+ is available, thus use new safeAreaLayoutGuide, but only adjustingToFitBars
        // The reason for this is safeAreaLayoutGuide will take into account any bar that may be used
        // If for some reason user doesn't want to adjust to bars, then keep the old center constraints
        if source.emptyStateViewAdjustsToFitBars {
            // Adjust constraint to fit new big title bars, etc
            centerX.isActive = false
            centerX = emptyView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
            centerX.isActive = true
            
            centerY.isActive = false
            centerY = emptyView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
            centerY.isActive = true
            
        }
        
        // Return & call the did show view delegate
        self.emptyStateDelegate?.emptyStateViewDidShow(view: emptyView)
    }
    
    /// Private helper method which will create the empty state view if not created, or show it if hidden
    private func showView(for source: UIEmptyStateDataSource) -> UIView {
        if let createdView = emptyStateView {
            // View has been created, update it and then reshow
            createdView.isHidden = false
            guard let view = createdView as? UIEmptyStateView else { return createdView}
            
            view.backgroundColor = source.emptyStateBackgroundColor
            view.title = source.emptyStateTitle
            view.image = source.emptyStateImage
            view.imageSize = source.emptyStateImageSize
            view.buttonTitle = source.emptyStateButtonTitle
            view.buttonImage = source.emptyStateButtonImage
            view.buttonSize = source.emptyStateButtonSize
            view.detailMessage = source.emptyStateDetailMessage
            view.spacing = source.emptyStateViewSpacing
            view.backgroundColor = source.emptyStateBackgroundColor

            // Animate now
            if source.emptyStateViewCanAnimate && source.emptyStateViewAnimatesEverytime {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(forView: view,
                                                   animationDuration: source.emptyStateViewAnimationDuration,
                                                   completion:
                        { finished in
                            
                            self.emptyStateDelegate?.emptyStateViewAnimationCompleted(forEmptyStateView: view,
                                                                                      didFinish: finished)
                        })
                }
            }
            
            return view
        
        } else {
            // We can create the view now
            let newView = source.emptyStateView
            // Add to emptyStateView property
            emptyStateView = newView
            // Add as a subView, bring it infront of the tableView
            self.view.addSubview(newView)
            self.view.bringSubview(toFront: newView)
            // Animate now
            if source.emptyStateViewCanAnimate {
                DispatchQueue.main.async {
                    source.emptyStateViewAnimation(forView: newView,
                                                   animationDuration: source.emptyStateViewAnimationDuration,
                                                   completion:
                        { finished in
                            
                            self.emptyStateDelegate?.emptyStateViewAnimationCompleted(forEmptyStateView: newView,
                                                                                      didFinish: finished)
                        })
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
        self.reloadEmptyState(forTableView: self.tableView)
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
        
        self.reloadEmptyState(forCollectionView: collectionView)
    }
}


