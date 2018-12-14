//
//  BetterButton.h
//  netstation_aplus
//
//  Created by HIEN DEP TRAI on 2/8/17.
//  Copyright © 2017 HIEN PHAM. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface BTButton : UIButton
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, copy) IBInspectable UIColor *fillColorNormal;
@property (nonatomic, copy) IBInspectable UIColor *strokeColorNormal;
@property (nonatomic, copy) IBInspectable UIColor *fillColorHighlighted;
@property (nonatomic, copy) IBInspectable UIColor *strokeColorHighlighted;
@property (nonatomic, copy) IBInspectable UIColor *fillColorSelected;
@property (nonatomic, copy) IBInspectable UIColor *strokeColorSelected;
@property (nonatomic, copy) IBInspectable UIColor *fillColorDisabled;
@property (nonatomic, copy) IBInspectable UIColor *strokeColorDisabled;
@property (nonatomic, assign) IBInspectable BOOL roundAsMuchAsPossible;
@property (nonatomic, assign) IBInspectable BOOL highlightedEnabled;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *components;
@property (nonatomic, assign) IBInspectable BOOL roundedAllCorners;
@property (nonatomic, assign) IBInspectable BOOL roundedTopLeft;
@property (nonatomic, assign) IBInspectable BOOL roundedTopRight;
@property (nonatomic, assign) IBInspectable BOOL roundedBottomRight;
@property (nonatomic, assign) IBInspectable BOOL roundedBottomLeft;
@end
