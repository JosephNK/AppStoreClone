//
//  ReadMoreLabelView.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 24..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

@IBDesignable class ReadMoreLabelView: UIView {
    
    /// 텍스트
    @IBInspectable var text: String = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." {
        didSet {
            titleLabel.text = text
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// 텍스트 색상
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet {
            titleLabel.textColor = textColor
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// 텍스트 폰트
    @IBInspectable var textFont: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            titleLabel.font = textFont
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// 텍스트 라벨 NumberLineCount
    @IBInspectable var textNumberLineCount: Int = 3 {
        didSet {
            titleLabel.numberOfLines = textNumberLineCount
            //self.setNeedsUpdateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// 더보기 버튼 타이틀
    @IBInspectable var readMoreTitle: String = "Read More" {
        didSet {
            readMoreButton.setTitle(readMoreTitle, for: UIControl.State.normal)
        }
    }
    
    /// 더보기 버튼 타이틀 색상
    @IBInspectable var readMoreTitleColor: UIColor = UIColor.blue {
        didSet {
            readMoreButton.setTitleColor(readMoreTitleColor, for: UIControl.State.normal)
        }
    }
    
    /// 더보기 버튼 타이틀 폰트
    @IBInspectable var readMoreTitleFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold) {
        didSet {
            readMoreButton.titleLabel?.font = readMoreTitleFont
        }
    }
    
    /// 더보기 버튼 클릭 Handler 정의
    typealias ReadMoreButtonHandler = (_ view: ReadMoreLabelView) -> Void
    
    /// 더보기 버튼 클릭 Handler
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
    
    /**
     더보기 버튼 숨김 처리 함수
     - parameters:
     - hidden: 숨김여부
     */
    func isReadMoreButtonHidden(_ hidden: Bool){
        readMoreButton.isHidden = hidden
    }
    
    /**
     텍스트 라벨이 실제 보이는 라인 수 가져오는 함수
     - returns: 라인수
     */
    func getVisibleNumberLines() -> Int {
        return titleLabel.numberOfVisibleLines
    }
    
    /**
     더보기 버튼 클릭 이벤트 핸들러 함수
     - parameters:
     - handler: handler block
     */
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
