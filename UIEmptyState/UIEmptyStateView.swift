//
//  UIEmptyStateView.swift
//  UIEmptyState
//
//  Created by Luis Padron on 1/31/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

open class UIEmptyStateView: UIView {
    
    // MARK: - Properties
    
    /// The title for the titleView
    open var title: NSAttributedString
    /// The image for the imageView
    open var image: UIImage?
    /// The button title for the button
    open var buttonTitle: NSAttributedString?
    /// The image for the button
    open var buttonImage: UIImage?
    /// The detail message for the detail label
    open var detailMessage: NSAttributedString?
    /// The spacing in between each of the views
    open var spacing: CGFloat = 20 {
        didSet {
            self.contentView.spacing = self.spacing
        }
    }
    
    /// The content views which wraps all subviews around it, of type UIStackView
    open lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.imageView, self.titleView, self.button])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = self.spacing
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    
    /// The title view which displays the value of `title`, place below the image view
    open lazy var titleView: UILabel = {
        let view = UILabel()
        view.attributedText = self.title
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.sizeToFit()
        view.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        return view
    }()
    
    /// The image view which displays the value of `image`, placed above the title label
    open lazy var imageView: UIImageView = {
        let view = UIImageView(image: self.image)
        view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    /// The button for the empty state view, title is set to the value of `buttonTitle`, place at the bottom of the view
    open lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setAttributedTitle(self.buttonTitle, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    /// The optional detail view, placed under title view, only displayed if detailMessage has a value
    open var detailView: UILabel?
    
    // MARK: - Initializers
    
    public required init(frame: CGRect, title: NSAttributedString) {
        self.title = title
        super.init(frame: frame)
        self.contentView.addArrangedSubview(titleView)
        self.initSubviews()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func initSubviews() {
        // Create the stack view which will enclose the other subviews
        self.addSubview(contentView)
    
        // Constrain stackview to the center of the view
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
