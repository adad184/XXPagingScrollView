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
                self.scrollView.snp.makeConstraints({ (make) -> Void in
                    make.width.equalTo(self.pagingWidth)
                })
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
                self.scrollView.snp.makeConstraints({ (make) -> Void in
                    make.height.equalTo(self.pagingHeight)
                })
            }
        }
    }

    private class XXReachableScrollView:UIScrollView {

        override func point(inside: CGPoint, with event: UIEvent?) -> Bool {
            return true
        }

    }

    public lazy var scrollView:UIScrollView! = {
        var v = XXReachableScrollView()
        v.clipsToBounds = false
        v.isPagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
        }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    private func setup() {

        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.width.equalTo(self.pagingWidth).priority(.low)
            make.height.equalTo(self.pagingHeight).priority(.low)
            self.widthContraint = make.width.equalTo(self.snp.width).priority(.high).constraint
            self.heightContraint = make.height.equalTo(self.snp.height).priority(.high).constraint
        }
    }

}
