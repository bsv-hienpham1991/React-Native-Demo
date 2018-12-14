//
//  RoundedView.h
//  DemoRadius
//
//  Created by Luu Duc Hoa on 3/28/16.
//  Copyright © 2016 Luu Duc Hoa. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE
@interface BTView : UIView
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, copy) IBInspectable UIColor *strokeColor;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable BOOL roundAsMuchAsPossible;
@property (nonatomic, assign) IBInspectable BOOL roundedAllCorners;
@property (nonatomic, assign) IBInspectable BOOL roundedTopLeft;
@property (nonatomic, assign) IBInspectable BOOL roundedTopRight;
@property (nonatomic, assign) IBInspectable BOOL roundedBottomRight;
@property (nonatomic, assign) IBInspectable BOOL roundedBottomLeft;
@end
