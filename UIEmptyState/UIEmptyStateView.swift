//
//  UIEmptyStateView.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

/// A UIView which has a stack view and inside the stackview are 1-4 other views
/// This view is used as the default view for the `emptyStateView` in the `UIEmptyStateDataSource`
open class UIEmptyStateView: UIView {
    
    // MARK: - Properties
    
    /// The delegate for the view, gets called when user taps button or self
    open weak var delegate: UIEmptyStateDelegate?
    
    /// The title for the titleView
    open var title: NSAttributedString {
        didSet {
            // Need to remove the constraints and then add them back in after calling size to fit
            titleView.removeConstraints(titleView.constraints)
            self.titleView.attributedText = self.title
            titleView.sizeToFit()
            titleView.widthAnchor.constraint(equalToConstant: titleView.frame.width).isActive = true
            titleView.heightAnchor.constraint(equalToConstant: titleView.frame.height).isActive = true
        }
    }
    /// The image for the imageView
    open var image: UIImage? {
        didSet {
            guard let img = image else { return }
            imageView.image = img
            handleAdding(view: imageView)
        }
    }
    
    /// The button title for the button
    open var buttonTitle: NSAttributedString? {
        didSet {
            guard let buttTitle = buttonTitle else { return }
            button.setAttributedTitle(buttTitle, for: .normal)
            handleAdding(view: button)
        }
    }
    
    /// The image for the button
    open var buttonImage: UIImage? {
        didSet {
            guard let buttImage = buttonImage else { return }
            button.setBackgroundImage(buttImage, for: .normal)
            handleAdding(view: button)
        }
    }
    
    /// The size of the button
    open var buttonSize: CGSize? {
        didSet {
            guard let size = buttonSize else { return }
            // Remove old constraints
            button.removeConstraints(button.constraints)
            button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    /// The detail message for the detail label
    open var detailMessage: NSAttributedString? {
        didSet {
            guard let message = detailMessage else { return }
            // Need to remove the constraints and then add them back in after calling size to fit
            detailView.removeConstraints(detailView.constraints)
            detailView.attributedText = message
            detailView.sizeToFit()
            detailView.widthAnchor.constraint(equalToConstant: detailView.frame.width).isActive = true
            detailView.heightAnchor.constraint(equalToConstant: detailView.frame.height).isActive = true
            handleAdding(view: detailView)
        }
    }
    /// The spacing in between each of the views
    open var spacing: CGFloat? {
        didSet {
            self.contentView.spacing = spacing ?? 0
        }
    }
    
    // MARK: - Initializers
    
    /// Initializer for `UIEmptyStateView`, requires a frame and an `NSAttributedString` which will be used as it's title
    public required init(frame: CGRect, title: NSAttributedString) {
        self.title = title
        super.init(frame: frame)
        self.initializeViews()
    }
    
    /// Unused initializer currently
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    /// Private method to initialize the views and add gesture recognizer
    private func initializeViews() {
        // Add gesture recognizer to view
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewWasTouched)))
        // Set up the stack view
        contentView.axis = .vertical
        contentView.distribution = .equalSpacing
        contentView.alignment = .center
        contentView.backgroundColor = UIColor.red
        contentView.spacing = spacing ?? 0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(titleView)
        
        self.addSubview(contentView)
        // Add center constraints
        // Add center constraints
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    /// Handles adding the views to the stack view
    private func handleAdding(view: UIView) {
        // The order we want is 1. Image View, 2. Title Label, 3. Detail Label, 4. Button
        // If already added we can return
        if self.subviews.index(of: view) != nil { return }
        
        // Tags correspond to the views AND the order we want them in
        switch view.tag {
        case 1:
            contentView.insertArrangedSubview(view, at: 0)
        case 2:
            contentView.insertArrangedSubview(view, at: 1)
        case 3:
            if contentView.arrangedSubviews.count == 3 { contentView.insertArrangedSubview(view, at: 2) }
            else { contentView.insertArrangedSubview(view, at: contentView.arrangedSubviews.count) }
        case 4:
            contentView.insertArrangedSubview(view, at: contentView.arrangedSubviews.count)
        default:
            return
        }
    }
    
    // MARK: - Actions
    
    /// Selector for when `self` has been tapped, calls the delegate
    @objc private func viewWasTouched(view: UIView) {
        delegate?.emptyStateViewWasTapped(view: self)
    }
    
    /// Selector for when the button inside the contentView has been tapped, calls the delegate
    @objc private func buttonTouched(button: UIButton) {
        delegate?.emptyStatebuttonWasTapped(button: button)
    }
    
    
    // MARK: - Subviews
    
    /// The content view which encloses the rest of the subviews, of type UIStackView
    open lazy var contentView = UIStackView()
    
    /// The title view which displays the value of `title`, place below the image view
    open lazy var titleView: UILabel = {
        let view = UILabel()
        view.attributedText = self.title
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.tag = 2
        return view
    }()
    
    /// The image view which displays the value of `image`, placed above the title label
    open lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.contentMode = .scaleAspectFit
        view.tag = 1
        return view
    }()
    
    /// The button for the empty state view, title is set to the value of `buttonTitle`, placed at the bottom of the view
    open lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tag = 4
        // Constrain button to size of text plus 20 points of padding
        let textSize = self.buttonTitle?.size()
        button.heightAnchor.constraint(equalToConstant: (textSize?.height ?? 30) + 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: (textSize?.width ?? 200) + 20).isActive = true
        // Add target to button tap
        button.addTarget(self, action: #selector(self.buttonTouched), for: .touchUpInside)
        return button
    }()
    
    /// The optional detail view, placed under title view, only displayed if detailMessage has a value
    open lazy var detailView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.tag = 3
        return view
    }()
}
