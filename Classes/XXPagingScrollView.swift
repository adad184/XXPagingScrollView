//
//  XXPagingScrollView.swift
//  XXPagingScrollView
//
//  Created by Ralph Li on 6/10/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

import UIKit
import SnapKit

public class XXPagingScrollView: UIView {

    private var widthContraint:Constraint? = nil
    private var heightContraint:Constraint? = nil
    
    /// 0 means regular paging mode (as long as self)
    public var pagingWidth:CGFloat = 0 {
        didSet {
            if pagingWidth.isZero {
                widthContraint?.activate()
            }
            else {
                widthContraint?.deactivate()
                self.scrollView.snp_updateConstraints{ (make) -> Void in
                    make.width.equalTo(self.pagingWidth)
                }
            }
        }
    }
    
    /// 0 means regular paging mode (as long as self)
    public var pagingHeight:CGFloat = 0 {
        didSet {
            if pagingHeight.isZero {
                heightContraint?.activate()
            }
            else {
                heightContraint?.deactivate()
                self.scrollView.snp_updateConstraints{ (make) -> Void in
                    make.height.equalTo(self.pagingHeight)
                }
            }
        }
    }
    
    private class XXReachableScrollView:UIScrollView {
        
        override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
            return true
        }
        
    }
    
    public lazy var scrollView:UIScrollView! = {
        var v = XXReachableScrollView()
        v.clipsToBounds = false
        v.pagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
        }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    private func setup() {
        
        self.addSubview(self.scrollView)
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.width.equalTo(self.pagingWidth).priorityLow()
            make.height.equalTo(self.pagingHeight).priorityLow()
            self.widthContraint = make.width.equalTo(self.snp_width).priorityHigh().constraint
            self.heightContraint = make.height.equalTo(self.snp_height).priorityHigh().constraint
        }
    }

}
