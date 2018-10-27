//
//  ReadMoreLabelView.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 24..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

@IBDesignable class ReadMoreLabelView: UIView {
    
    @IBInspectable var text: String = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." {
        didSet {
            titleLabel.text = text
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet {
            titleLabel.textColor = textColor
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var textFont: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            titleLabel.font = textFont
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var textNumberLineCount: Int = 3 {
        didSet {
            titleLabel.numberOfLines = textNumberLineCount
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var readMoreTitle: String = "Read More" {
        didSet {
            readMoreButton.setTitle(readMoreTitle, for: UIControl.State.normal)
        }
    }
    
    @IBInspectable var readMoreTitleColor: UIColor = UIColor.blue {
        didSet {
            readMoreButton.setTitleColor(readMoreTitleColor, for: UIControl.State.normal)
        }
    }
    
    @IBInspectable var readMoreTitleFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold) {
        didSet {
            readMoreButton.titleLabel?.font = readMoreTitleFont
        }
    }
    
    typealias ReadMoreButtonHandler = (_ view: ReadMoreLabelView) -> Void
    
    private var readMoreButtonHandler: ReadMoreButtonHandler?
    
    private lazy var titleLabel: AutoSizingLabel = {
        var label = AutoSizingLabel()
        label.text = self.text
        label.textColor = self.textColor
        label.font = self.textFont
        label.numberOfLines = self.textNumberLineCount
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        button.setTitle(self.readMoreTitle, for: UIControl.State.normal)
        button.setTitleColor(self.readMoreTitleColor, for: UIControl.State.normal)
        button.titleLabel?.font = self.readMoreTitleFont
        return button
    }()

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialization()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        //let size = super.intrinsicContentSize
        //let size1 = self.titleLabel.intrinsicContentSize
        let lbBoundsSize = self.titleLabel.bounds.size

        let w = lbBoundsSize.width
        let h = lbBoundsSize.height
        return CGSize(width: w, height: h)
    }
    
    // MARK: Initializations
    func initialization() {
        self.addSubview(titleLabel)
        self.addSubview(readMoreButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        readMoreButton.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.height.equalTo(20.0)
            make.bottom.equalTo(self).offset(1.5)
        }
        
        readMoreButton.addAction(for: UIControl.Event.touchUpInside) { [weak self] in
            if let h = self?.readMoreButtonHandler {
                h(self!)
            }
        }
    }
    
    func isReadMoreButtonHidden(_ hidden: Bool){
        readMoreButton.isHidden = hidden
    }
    
    func getVisibleNumberLines() -> Int {
        return titleLabel.numberOfVisibleLines
    }
    
    func addReadMoreClicked(handler: (ReadMoreButtonHandler)? = nil) {
        readMoreButtonHandler = handler
    }
    
}


class AutoSizingLabel: UILabel {
    
    override var bounds: CGRect {
        didSet {
            if (bounds.size.width != oldValue.size.width) {
                self.setNeedsUpdateConstraints();
            }
        }
    }
    
    override func updateConstraints() {
        if(self.preferredMaxLayoutWidth != self.bounds.size.width) {
            self.preferredMaxLayoutWidth = self.bounds.size.width
        }
        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        if self.numberOfLines == 0 {
            // There's a bug where intrinsic content size may be 1 point too short
            size.height += 1
        }
        
        return size
    }
    
}
