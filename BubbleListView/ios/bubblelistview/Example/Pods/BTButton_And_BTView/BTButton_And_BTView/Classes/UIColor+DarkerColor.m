//
//  UIColor+DarkerColor.m
//  anpanman
//
//  Created by HIEN DEP TRAI on 8/1/16.
//  Copyright © 2016 BraveSoft Vietnam. All rights reserved.
//

#import "UIColor+DarkerColor.h"

@implementation UIColor (DarkerColor)

- (UIColor *)lighterColorWithOffset:(CGFloat)offset {
    
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + offset, 1.0)
                               green:MIN(g + offset, 1.0)
                                blue:MIN(b + offset, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorWithOffset:(CGFloat)offset {
    
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - offset, 0.0)
                               green:MAX(g - offset, 0.0)
                                blue:MAX(b - offset, 0.0)
                               alpha:a];
    return nil;
}

- (UIColor *)lighterColor
{
    UIColor *lighterColor = [self lighterColorWithOffset:0.2f];
    return lighterColor;
}

- (UIColor *)darkerColor
{
    UIColor *darkerColor = [self darkerColorWithOffset:0.2f];
    return darkerColor;
}

@end
