//
//  UIColor+DarkerColor.h
//  anpanman
//
//  Created by HIEN DEP TRAI on 8/1/16.
//  Copyright © 2016 BraveSoft Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DarkerColor)
- (UIColor *)lighterColor;
- (UIColor *)darkerColor;
- (UIColor *)lighterColorWithOffset:(CGFloat)offset;
- (UIColor *)darkerColorWithOffset:(CGFloat)offset;
@end
