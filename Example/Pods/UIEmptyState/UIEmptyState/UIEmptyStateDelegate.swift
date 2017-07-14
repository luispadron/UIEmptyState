//
//  UIEmptyStateDelegate.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

/**
 The delegate for UIEmptyStateView
 
 **Important:**
 This delegate and its functions are only used when using `UIEmptyStateView`.
 If you will provide a custom view in the `UIEmptyStateDataSource` `viewForEmptyState`
 you must handle how this delegate operates
*/
public protocol UIEmptyStateDelegate: class {
    /**
     The call back for when the `emptyStateView` will be shown on screen
     
     - parameters:
     - view: The view that is will show
     */
    func emptyStateViewWillShow(view: UIView)
    
    /**
     The call back for when the `emptyStateView` is now shown on screen
 
     - parameters:
         - view: The view that is now shown
     */
    func emptyStateViewDidShow(view: UIView)
    
    /**
     The call back for when the `emptyStateView` will be hidden
     
     - parameters:
     - view: The view that will be hidden
     */
    func emptyStateViewWillHide(view: UIView)
    
    /**
     The call back for when the button inside the emptyStateView is tapped
 
     - parameters:
         - button: The button that was tapped
     */
    func emptyStatebuttonWasTapped(button: UIButton)
    
    /**
     The call back for when the emptyStateView itself is tapped
 
     - parameters:
         - view: The view that was tapped
     */
    func emptyStateViewWasTapped(view: UIView)
    
    /**
     The call back for when the animation of the emptyStateView is done
     - paramaters:
         - view: The view which finished animating
         - didFinish: Whether the animation finished completely, i.e not interrupted
     */
    func emptyStateViewAnimationCompleted(for view: UIView, didFinish: Bool)
}

/// Extension to add default conformance to UIViewController, by default the method bodies are empty
extension UIEmptyStateDelegate where Self: UIViewController {
    /// Default empty implementation of `emptyStateViewWillShow`
    public func emptyStateViewWillShow(view: UIView) { }
    /// Default empty implementation of `emptyStateViewDidShow`
    public func emptyStateViewDidShow(view: UIView) { }
    /// Default empty implementation of `emptyStateViewWillHide`
    public func emptyStateViewWillHide(view: UIView) { }
    /// Default empty implementation of `emptyStateButtonWasTapped`
    public func emptyStatebuttonWasTapped(button: UIButton) { }
    /// Default empty implementation of `emptyStateViewWasTapped`
    public func emptyStateViewWasTapped(view: UIView) { }
    /// Default empty implementation of `emptyStateViewAnimationCompleted`
    public func emptyStateViewAnimationCompleted(for view: UIView, didFinish: Bool) { }
}
