//
//  ViewController.swift
//  XXPagingScrollView
//
//  Created by Ralph Li on 6/10/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    let minTinderScale:CGFloat = 0.7
    let maxTinderScale:CGFloat = 1.0
    let minTinderIconColor:UIColor = UIColor.grayColor()
    let maxTinderIconColor:UIColor = UIColor.orangeColor()
    
    var tinderScrollView:XXPagingScrollView = {
        let v = XXPagingScrollView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    var pagingScrollView:XXPagingScrollView = {
        let v = XXPagingScrollView()
        v.backgroundColor = UIColor.lightGrayColor()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        // tinder-like example
        let icons = ["conf","map","msg","photo"]
        let iconSize:CGSize = CGSizeMake(40, 40)
        self.view.addSubview(self.tinderScrollView)
        self.tinderScrollView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 0, 0))
            make.height.equalTo(44)
        }
        self.tinderScrollView.scrollView.delegate = self;
        self.tinderScrollView.pagingWidth = (UIScreen.mainScreen().bounds.width - 60)/2
        for (index,value) in enumerate(icons) {
            let iv = UIImageView(frame: CGRectMake(0, 0, iconSize.width, iconSize.height))
            self.tinderScrollView.scrollView.addSubview(iv)
            iv.image = UIImage(named: value)?.imageWithRenderingMode(.AlwaysTemplate)
            iv.contentMode = UIViewContentMode.ScaleAspectFill
            iv.center = CGPointMake(self.tinderScrollView.pagingWidth * CGFloat(index) + self.tinderScrollView.pagingWidth/2, 44/2)
        }
        self.tinderScrollView.scrollView.contentSize = CGSizeMake(self.tinderScrollView.pagingWidth*CGFloat(icons.count), 44)
        self.adjustTinderAppearence()
        
        // custom paging example
        let cardSize:CGSize = CGSizeMake(270, 360)
        let cardCount:CGFloat = 10
        self.view.addSubview(self.pagingScrollView)
        self.pagingScrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        self.pagingScrollView.pagingWidth  = cardSize.width
        self.pagingScrollView.pagingHeight = cardSize.height
        
        for i in 0..<Int(cardCount) {
            let view = UIView(frame: CGRectMake(CGFloat(i)*cardSize.width, 0, cardSize.width, cardSize.height))
            let card = UIView(frame: CGRectInset(view.bounds, 10, 10))
            card.backgroundColor = self.randonColor()
            card.layer.cornerRadius = 10;
            view.addSubview(card)
            pagingScrollView.scrollView.addSubview(view)
        }
        self.pagingScrollView.scrollView.contentSize = CGSizeMake(cardSize.width*cardCount, cardSize.height)
        
    }
    
    func randonColor() -> UIColor {
        
        var randomR:CGFloat = CGFloat(drand48())
        var randomG:CGFloat = CGFloat(drand48())
        var randomB:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomR, green: randomG, blue: randomB, alpha: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.adjustTinderAppearence()
    }
    
    
    func adjustTinderAppearence() {
        
        func getColor(percent:CGFloat) -> UIColor {
            
            var redStart: CGFloat = 0
            var greenStart : CGFloat = 0
            var blueStart: CGFloat = 0
            var alphaStart : CGFloat = 0
            self.maxTinderIconColor.getRed(&redStart, green: &greenStart, blue: &blueStart, alpha: &alphaStart)
            
            var redFinish: CGFloat = 0
            var greenFinish: CGFloat = 0
            var blueFinish: CGFloat = 0
            var alphaFinish: CGFloat = 0
            self.minTinderIconColor.getRed(&redFinish, green: &greenFinish, blue: &blueFinish, alpha: &alphaFinish)
            
            return UIColor(red: (redStart - ((redStart-redFinish) * percent)) , green: (greenStart - ((greenStart-greenFinish) * percent)) , blue: (blueStart - ((blueStart-blueFinish) * percent)) , alpha: (alphaStart - ((alphaStart-alphaFinish) * percent)));
        }
        
        for (index,value) in enumerate(self.tinderScrollView.scrollView.subviews as! [UIImageView]) {
            
            let iv = value as UIImageView
            
            var percent:CGFloat = fabs((iv.center.x - (self.tinderScrollView.scrollView.contentOffset.x+self.tinderScrollView.pagingWidth/2))/self.tinderScrollView.pagingWidth)
            percent = percent > 1 ? 1 : percent
            
            var scale = self.maxTinderScale - (self.maxTinderScale-self.minTinderScale) * percent
            iv.transform = CGAffineTransformMakeScale(scale, scale)
            iv.tintColor = getColor(percent)
        }
    }
}

