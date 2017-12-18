//
//  UIEmptyStateView.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

private extension UILabel {
    /// Returns the height that would be expected for the string, with a max width
    func expectedHeight(forWidth width: CGFloat) -> CGFloat {
        guard let txt = self.text else {
            return 0.0
        }
        
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        #if swift(>=4.0)
            let attrString = NSAttributedString(string: txt, attributes: [.font: self.font])
        #else
            let attrString = NSAttributedString(string: txt, attributes: [NSFontAttributeName: self.font])
        #endif
        
        let expectedRect = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
        return ceil(expectedRect.size.height)
        
    }
}

/// A UIView which has a stack view and inside the stackview are 1-4 other views
/// This view is used as the default view for the `emptyStateView` in the `UIEmptyStateDataSource`
open class UIEmptyStateView: UIView {
    
    // MARK: - Properties
    
    /// The width constraint for the view, changed whenever reloading the empty state
    private var widthConstraint: NSLayoutConstraint?
    
    /// The height constraint for the view, changed whenever reloading the empty state
    private var heightConstraint: NSLayoutConstraint?
    
    /// The centerY constraint for the view
    private var centerYConstraint: NSLayoutConstraint?
    
    /// The delegate for the view, gets called when user taps button or self
    open weak var delegate: UIEmptyStateDelegate?
    
    /// The title for the titleView
    open var title: NSAttributedString {
        didSet {
            self.titleLabel.attributedText = self.title
            self.setNeedsUpdateConstraints()
        }
    }
    
    /// The image for the imageView
    open var image: UIImage? {
        didSet {
            // If the image has been removed (by passing nil) then remove the image view as well
            guard let img = image else {
                if oldValue != nil {
                    self.imageView.removeFromSuperview()
                    self.setNeedsUpdateConstraints()
                }
                return
            }
            
            imageView.image = img
            self.setNeedsUpdateConstraints()
            handleAdding(view: imageView)
        }
    }
    
    /// The size for image view
    open var imageSize: CGSize? { didSet { self.setNeedsUpdateConstraints() } }
    
    /// The tintColor for image view
    open var imageViewTintColor: UIColor? {
        didSet {
            guard let tintColor = imageViewTintColor else {
                return
            }
            imageView.tintColor = tintColor
        }
    }
    
    /// The offset of the vertical axis
    open var centerYOffset: CGFloat? {
        didSet {
            guard let offset = centerYOffset else {
                return
            }
            centerYConstraint?.constant = offset
        }
    }

    
    /// The button title for the button
    open var buttonTitle: NSAttributedString? {
        didSet {
            // If the button title has been removed (by passing nil)
            // then remove the button view if also has no button image
            guard let buttTitle = buttonTitle else {
                if oldValue != nil {
                    if buttonImage == nil {
                        self.button.removeFromSuperview()
                        self.setNeedsUpdateConstraints()
                    }
                }
                return
            }
            
            button.setAttributedTitle(buttTitle, for: .normal)
            self.setNeedsUpdateConstraints()
            handleAdding(view: button)
        }
    }
    
    /// The image for the button
    open var buttonImage: UIImage? {
        didSet {
            // If the button image has been removed (by passing nil)
            // then remove the button view if also has no button title
            guard let buttImage = buttonImage else {
                if oldValue != nil {
                    if buttonTitle == nil {
                        self.button.removeFromSuperview()
                        self.setNeedsUpdateConstraints()
                    }
                }
                return
            }
            
            button.setBackgroundImage(buttImage, for: .normal)
            self.setNeedsUpdateConstraints()
            handleAdding(view: button)
        }
    }
    
    /// The size of the button
    open var buttonSize: CGSize? {
        didSet {
            guard buttonSize != nil else { return }
            self.setNeedsUpdateConstraints()
        }
    }
    
    /// The detail message for the detail label
    open var detailMessage: NSAttributedString? {
        didSet {
            // If the detail message has been removed (by passing nil) remove the detail view
            guard let message = detailMessage else {
                if oldValue != nil {
                    self.detailLabel.removeFromSuperview()
                    self.setNeedsUpdateConstraints()
                }
                return
            }
            
            detailLabel.attributedText = message
            self.setNeedsUpdateConstraints()
            handleAdding(view: detailLabel)
        }
    }
    
    /// The spacing in between each of the views
    open var spacing: CGFloat? { didSet { self.contentView.spacing = spacing ?? 0 } }
    
    // MARK: - Initializers
    
    /// Initializer for `UIEmptyStateView`,
    /// requires a frame and an `NSAttributedString` which will be used as it's title
    public required init(frame: CGRect, title: NSAttributedString) {
        self.title = title
        super.init(frame: frame)
        self.initializeViews()
    }
    
    /// Unused initializer currently
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    /// Override for update constraints, adds the auto layout constraints for the stackviews subviews.
    ///
    /// ** IMPORTANT: **
    /// This method will remove all constraints that a part of the `contentView` so do not add
    /// constraints to these views.
    open override func updateConstraints() {
        super.updateConstraints()
        
        // Loop through the stack views constraints and add the appropriate constraints
        for subview in contentView.subviews {
            // Remove constraint before adding it again
            subview.removeConstraints(subview.constraints)
            
            if let label = subview as? UILabel {
                // Try to get readable width of the main view that the empty state view is inside of
                // This will allow for better sizing of label
                if let labelWidth = contentView.superview?.superview?.readableContentGuide.layoutFrame.width {
                    label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
                    let labelHeight = label.expectedHeight(forWidth: labelWidth)
                    label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
                } else {
                    label.sizeToFit()
                    label.widthAnchor.constraint(equalToConstant: label.frame.width).isActive = true
                    label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
                }
                
            } else if let imageView = subview as? UIImageView {
                let size = imageSize ?? CGSize(width: 100, height: 100)
                imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                
            } else if let button = subview as? UIButton {
                let size = buttonSize ?? self.buttonTitle?.size() ??
                    self.buttonImage?.size ??
                    CGSize(width: 0, height: 0)
                
                button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
        }
        
        // Layout content view to get height and width
        contentView.layoutIfNeeded()
        
        // Set width and height constraints for enclosing view
        widthConstraint?.isActive = false
        widthConstraint = self.widthAnchor.constraint(equalToConstant: contentView.frame.width)
        widthConstraint?.isActive = true
        
        heightConstraint?.isActive = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: contentView.frame.height)
        heightConstraint?.isActive = true
    }
    
    // MARK: - Helper methods
    
    /// Private method to initialize the views and add gesture recognizer
    private func initializeViews() {
        // Since self is just a container view, to make the subviews accessible remove accessibilty from self
        self.isAccessibilityElement = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // Add gesture recognizer to view
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewWasTouched)))
        // Set up the stack view
        contentView.axis = .vertical
        contentView.distribution = .equalSpacing
        contentView.alignment = .center
        contentView.backgroundColor = UIColor.red
        contentView.spacing = spacing ?? 0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(titleLabel)
        
        self.addSubview(contentView)
        // Add center constraints
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        centerYConstraint = contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        centerYConstraint?.isActive = true
    }
    
    /// Handles adding the views to the stack view
    private func handleAdding(view: UIView) {
        // The order we want is 1. Image View, 2. Title Label, 3. Detail Label, 4. Button
        // If already added we can return
        if contentView.subviews.index(of: view) != nil { return }
        
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
    open lazy var titleLabel: UILabel = {
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
        // Add target to button tap
        button.addTarget(self, action: #selector(self.buttonTouched), for: .touchUpInside)
        return button
    }()
    
    /// The optional detail view, placed under title view, only displayed if detailMessage has a value
    open lazy var detailLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.tag = 3
        return view
    }()
}

