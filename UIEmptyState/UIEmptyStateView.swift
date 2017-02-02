//
//  UIEmptyStateView.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

open class UIEmptyStateView: UIStackView {
    
    // MARK: - Properties
    
    /// The title for the titleView
    open var title: NSAttributedString {
        didSet {
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
            if self.subviews.index(of: imageView) == nil {
                self.addArrangedSubview(imageView)
            }
            imageView.image = img
        }
    }
    
    /// The button title for the button
    open var buttonTitle: NSAttributedString? {
        didSet {
            guard let buttTitle = buttonTitle else { return }
            if self.subviews.index(of: button) == nil {
                self.addArrangedSubview(button)
            }
            button.setAttributedTitle(buttTitle, for: .normal)
        }
    }
    /// The image for the button
    open var buttonImage: UIImage? {
        didSet {
            guard let buttImage = buttonImage else { return }
            if self.subviews.index(of: button) == nil {
                self.addArrangedSubview(button)
            }
            button.setBackgroundImage(buttonImage, for: .normal)
            button.setNeedsDisplay()
        }
    }
    
    /// The detail message for the detail label
    open var detailMessage: NSAttributedString? {
        didSet {
            guard let message = detailMessage else { return }
            if self.subviews.index(of: detailView) == nil {
                self.addArrangedSubview(detailView)
            }
            detailView.removeConstraints(detailView.constraints)
            detailView.attributedText = message
            detailView.sizeToFit()
            detailView.widthAnchor.constraint(equalToConstant: detailView.frame.width).isActive = true
            detailView.heightAnchor.constraint(equalToConstant: detailView.frame.height).isActive = true
        }
    }
    /// The spacing in between each of the views
    open var viewSpacing: CGFloat? {
        didSet {
            self.spacing = self.viewSpacing ?? 0
        }
    }
    
    /// The title view which displays the value of `title`, place below the image view
    open lazy var titleView: UILabel = {
        let view = UILabel()
        view.attributedText = self.title
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    /// The image view which displays the value of `image`, placed above the title label
    open lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    /// The button for the empty state view, title is set to the value of `buttonTitle`, place at the bottom of the view
    open lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    /// The optional detail view, placed under title view, only displayed if detailMessage has a value
    open lazy var detailView: UILabel = {
       let view = UILabel()
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    // MARK: - Initializers
    
    public required init(frame: CGRect, title: NSAttributedString) {
        self.title = title
        super.init(frame: frame)
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .center
        self.spacing = viewSpacing ?? 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(titleView)
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
