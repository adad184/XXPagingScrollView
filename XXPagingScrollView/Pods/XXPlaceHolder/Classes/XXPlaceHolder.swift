//
//  XXPlaceHolder.swift
//  XXPlaceHolder
//
//  Created by Ralph Li on 10/19/15.
//  Copyright © 2015 LJC. All rights reserved.
//

import UIKit

// MARK: - XXPlaceHolderConfig

public struct XXPlaceHolderConfig {
    
    public var backColor: UIColor  = UIColor.clearColor()
    public var arrowSize: CGFloat  = 3
    public var lineColor: UIColor  = UIColor.whiteColor()
    public var lineWidth: CGFloat  = 1
    public var frameColor: UIColor = UIColor.redColor()
    public var frameWidth: CGFloat = 0
    
    public var showArrow: Bool             = true
    public var showText: Bool              = true
    
    public var visible: Bool               = true
    public var autoDisplay: Bool           = false
    public var autoDisplaySystemView: Bool = false
    
    public var visibleMemberOfClasses: [AnyClass] = [AnyClass]()
    public var visibleKindOfClasses: [AnyClass]   = [AnyClass]()
    
    private let defaultMemberOfClasses: [AnyClass] = [
        UIImageView.self,
        UIButton.self,
        UILabel.self,
        UITextField.self,
        UITextView.self,
        UISwitch.self,
        UISlider.self,
        UIPageControl.self
    ];
}

// MARK: - XXPlaceHolder

public class XXPlaceHolder: UIView {
    
    public static var config: XXPlaceHolderConfig = XXPlaceHolderConfig()
    
    public var backColor: UIColor  = XXPlaceHolder.config.backColor {didSet{self.setNeedsDisplay()}}
    public var arrowSize: CGFloat  = XXPlaceHolder.config.arrowSize {didSet{self.setNeedsDisplay()}}
    public var lineColor: UIColor  = XXPlaceHolder.config.lineColor {didSet{self.setNeedsDisplay()}}
    public var lineWidth: CGFloat  = XXPlaceHolder.config.lineWidth {didSet{self.setNeedsDisplay()}}
    public var frameColor: UIColor = XXPlaceHolder.config.frameColor {didSet{self.setNeedsDisplay()}}
    public var frameWidth: CGFloat = XXPlaceHolder.config.frameWidth {didSet{self.setNeedsDisplay()}}
    
    public var showArrow: Bool = XXPlaceHolder.config.showArrow {didSet{self.setNeedsDisplay()}}
    public var showText: Bool  = XXPlaceHolder.config.showText {didSet{self.setNeedsDisplay()}}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        self.opaque = false
        self.contentMode = .Redraw
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    override public func drawRect(rect: CGRect) {
        
        let width = rect.size.width
        let height = rect.size.height
        
        let fontSize = 4 + min(width, height) / 20
        let arrowSize = CGFloat(self.arrowSize)
        let lineWidth = CGFloat(self.lineWidth)
        
        let font = UIFont.systemFontOfSize(fontSize)
        
        // fill the back
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
        CGContextSetLineJoin(ctx, .Miter)
        CGContextSetLineCap(ctx, .Round)
        
        CGContextFillRect(ctx, rect);
        
        
        // strike frame
        if ( self.frameWidth > 0 ) {
            
            let radius = self.frameWidth/2;
            
            CGContextSetLineWidth(ctx, self.frameWidth);
            CGContextSetStrokeColorWithColor(ctx, self.frameColor.CGColor)
            
            CGContextMoveToPoint(ctx, radius, radius)
            CGContextAddLineToPoint(ctx, radius, height - radius)
            CGContextAddLineToPoint(ctx, width - radius, height - radius)
            CGContextAddLineToPoint(ctx, width - radius, radius)
            CGContextAddLineToPoint(ctx, radius, radius)
            CGContextClosePath(ctx)
            
            CGContextStrokePath(ctx)
        }
        
        // strike lines & arrows
        if ( self.showArrow ) {
            
            let radius = self.frameWidth/2*3
            
            CGContextSetLineWidth(ctx, lineWidth)
            CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor)
            
            CGContextMoveToPoint(ctx, width/2, radius)
            CGContextAddLineToPoint(ctx, width/2, height-radius)
            CGContextMoveToPoint(ctx, width/2, radius)
            CGContextAddLineToPoint(ctx, width/2 - arrowSize, arrowSize + radius)
            CGContextMoveToPoint(ctx, width/2, radius)
            CGContextAddLineToPoint(ctx, width/2 + arrowSize, arrowSize + radius)
            CGContextMoveToPoint(ctx, width/2, height-radius)
            CGContextAddLineToPoint(ctx, width/2 - arrowSize, height - arrowSize - radius)
            CGContextMoveToPoint(ctx, width/2, height-radius)
            CGContextAddLineToPoint(ctx, width/2 + arrowSize, height - arrowSize - radius)
            
            CGContextMoveToPoint(ctx, radius, height/2)
            CGContextAddLineToPoint(ctx, width - radius, height/2)
            CGContextMoveToPoint(ctx, radius, height/2)
            CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 - arrowSize)
            CGContextMoveToPoint(ctx, radius, height/2)
            CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 + arrowSize)
            CGContextMoveToPoint(ctx, width - radius, height/2)
            CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 - arrowSize)
            CGContextMoveToPoint(ctx, width - radius, height/2)
            CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 + arrowSize)
            
            CGContextStrokePath(ctx);
        }
        
        // strike lines & arrows
        if ( self.showText && width >= 50 ) {
            // calculate the text area
            let text:NSString = "\(width) x \(height)" as NSString
            
            let textFontAttributes = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: self.lineColor
            ]
            let textSize = text.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: .UsesFontLeading, attributes: textFontAttributes, context: nil).size
            
            let rectWidth = ceil(textSize.width + 4.0)
            let rectHeight = ceil(textSize.height + 4.0)
            
            // clear the area behind the textz
            let strRect = CGRectMake(width/2 - rectWidth/2, height/2 - rectHeight/2, rectWidth, rectHeight)
            CGContextClearRect(ctx, strRect);
            CGContextSetLineWidth(ctx, 0);
            CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
            CGContextFillRect(ctx, strRect);
            
            // draw text
            CGContextSetFillColorWithColor(ctx, self.lineColor.CGColor);
            text.drawInRect(strRect, withAttributes: textFontAttributes)
        }
        
    }
}

// MARK: - UIView extension

public extension UIView
{
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if ( self == XXPlaceHolder.self ) {
            return;
        }
        
        func swizzleSelector(originalSelector:Selector, swizzledSelector:Selector) {
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(
                self,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(
                    self,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        
        dispatch_once(&Static.token) {
            swizzleSelector(Selector("didMoveToSuperview"), swizzledSelector: Selector("xx_didMoveToSuperview"))
        }
    }
    
    private func xx_didMoveToSuperview() -> UIView {
        self.xx_didMoveToSuperview()
        
        self.checkAutoDisplay()
        
        return self
    }
    
    private func checkAutoDisplay() {
        let config = XXPlaceHolder.config
        
        if self.isKindOfClass(XXPlaceHolder.self) {
            return
        }
        
        if config.autoDisplay {
            
            if ( NSBundle(forClass: UIView.self).bundlePath == NSBundle(forClass: self.dynamicType).bundlePath ) {
                
                if ( !config.autoDisplaySystemView ) {
                    var inWhiteList = false
                    for cls: AnyClass in config.defaultMemberOfClasses {
                        if self.isMemberOfClass(cls) {
                            inWhiteList = true
                            break;
                        }
                    }
                    
                    if ( !inWhiteList ) {
                        return
                    }
                }
            }
            
            if ( config.visibleMemberOfClasses.count > 0 ) {
                for cls: AnyClass in config.visibleMemberOfClasses {
                    if self.isMemberOfClass(cls) {
                        self.showPlaceHolder()
                        return
                    }
                }
            }
            else if ( config.visibleKindOfClasses.count > 0 ) {
                for cls: AnyClass in config.visibleKindOfClasses {
                    if self.isKindOfClass(cls) {
                        self.showPlaceHolder()
                        return
                    }
                }
            }
            else {
                self.showPlaceHolder()
            }
        }
    }
    
    public func getPlaceHolder() -> XXPlaceHolder? {
        return self.viewWithTag(XXPlaceHolder.self.hash() + self.hashValue) as? XXPlaceHolder
    }
    
    public func showPlaceHolder() {
        self.showPlaceHolderWith(XXPlaceHolder.config.lineColor)
    }
    
    public func showPlaceHolderWith(lineColor: UIColor) {
        self.showPlaceHolderWith(lineColor, backColor: XXPlaceHolder.config.backColor)
    }
    
    public func showPlaceHolderWith(lineColor: UIColor, backColor: UIColor) {
        let config = XXPlaceHolder.config
        self.showPlaceHolderWith(lineColor, backColor: backColor, arrowSize: config.arrowSize)
    }
    
    public func showPlaceHolderWith(lineColor: UIColor, backColor: UIColor, arrowSize: CGFloat) {
        self.showPlaceHolderWith(
            lineColor,
            backColor: backColor,
            arrowSize: arrowSize,
            lineWidth: XXPlaceHolder.config.lineWidth)
    }
    
    public func showPlaceHolderWith(lineColor: UIColor, backColor: UIColor, arrowSize: CGFloat, lineWidth: CGFloat) {
        self.showPlaceHolderWith(
            lineColor,
            backColor: backColor,
            arrowSize: arrowSize,
            lineWidth: lineWidth,
            frameWidth: XXPlaceHolder.config.frameWidth,
            frameColor: XXPlaceHolder.config.frameColor)
    }
    
    public func showPlaceHolderWith(lineColor: UIColor, backColor: UIColor, arrowSize: CGFloat, lineWidth: CGFloat, frameWidth: CGFloat, frameColor: UIColor) {
        #if RELEASE
            // do nothing
            #else
            
            var placeholder:XXPlaceHolder? = self.getPlaceHolder()
            
            if ( placeholder == nil) {
                let ph = XXPlaceHolder.init(frame: self.bounds)
                self.addSubview(ph)
                ph.tag = XXPlaceHolder.self.hash() + self.hashValue
                
                placeholder = ph
            }
            
            let ph = placeholder as XXPlaceHolder!
            
            ph.lineColor = lineColor
            ph.backColor = backColor
            ph.arrowSize = arrowSize
            ph.lineWidth = lineWidth
            ph.frameColor = frameColor
            ph.frameWidth = frameWidth
            ph.hidden = !XXPlaceHolder.config.visible
            
        #endif
    }
    
    public func showPlaceHolderWithAllSubviews() {
        print("showPlaceholderWithAllSubviews")
        self.showPlaceHolderWithAllSubviewsWith(UInt.max)
    }
    
    public func showPlaceHolderWithAllSubviewsWith(maxPath: UInt) {
        if ( maxPath > 0 ) {
            for v: UIView in self.subviews {
                v.showPlaceHolderWithAllSubviewsWith(maxPath - 1)
            }
        }
        self.showPlaceHolder()
    }
    
    public func hidePlaceHolder() {
        if let placeholder = self.getPlaceHolder() {
            placeholder.hidden = true
        }
    }
    
    public func hidePlaceHolderWithAllSubviews() {
        for v: UIView in self.subviews {
            v.hidePlaceHolderWithAllSubviews()
        }
        self.hidePlaceHolder()
    }
    
    public func removePlaceHolder() {
        if let placeholder = self.getPlaceHolder() {
            placeholder.removeFromSuperview()
        }
    }
    
    public func removePlaceHolderWithAllSubviews() {
        for v: UIView in self.subviews {
            v.removePlaceHolderWithAllSubviews()
        }
        self.removePlaceHolder()
    }
}
