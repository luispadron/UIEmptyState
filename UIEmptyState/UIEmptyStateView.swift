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
    
    open let title: NSAttributedString
    open let image: UIImage
    open let buttonTitle: NSAttributedString
    open var detailMessage: NSAttributedString?
    open var spacing: CGFloat = 20.0
    
    /// The title view which displays the value of `title`, place below the image view
    open lazy var titleView: UILabel = {
        let view = UILabel()
        view.attributedText = self.title
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The image view which displays the value of `image`, placed above the title label
    open lazy var imageView: UIImageView = {
        let view = UIImageView(image: self.image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The button for the empty state view, title is set to the value of `buttonTitle`, place at the bottom of the view
    open lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setAttributedTitle(self.buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// The optional detail view, placed under title view, only displayed if detailMessage has a value
    open var detailView: UILabel?
    
    // MARK: - Initializers
    
    public required init(frame: CGRect, title: NSAttributedString, image: UIImage, buttonTitle: NSAttributedString) {
        self.title = title
        self.image = image
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        self.initSubviews()
        self.backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let mainFrame = self.bounds
        titleView.frame = CGRect(x: 0, y: 0, width: mainFrame.width, height: mainFrame.height / 4)
        imageView.frame = CGRect(x: 0, y: titleView.frame.maxY + spacing, width: mainFrame.width, height: mainFrame.height / 4)
        button.frame = CGRect(x: 0, y: imageView.frame.maxY + spacing, width: mainFrame.width, height: mainFrame.height / 4)
    }
    
    // MARK: - Helper Methods
    
    private func initSubviews() {
        // Add the views as sub views
        self.addSubview(titleView)
        self.addSubview(imageView)
        self.addSubview(button)
        self.sizeToFit()
        
    }
    
}
