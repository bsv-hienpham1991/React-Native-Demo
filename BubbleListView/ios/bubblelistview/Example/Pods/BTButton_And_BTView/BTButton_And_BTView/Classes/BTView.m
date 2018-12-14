//
//  RoundedView.m
//  DemoRadius
//
//  Created by Luu Duc Hoa on 3/28/16.
//  Copyright © 2016 Luu Duc Hoa. All rights reserved.
//

#import "BTView.h"
#import "UIColor+DarkerColor.h"

@interface BTView()
@property (strong, nonatomic) CAShapeLayer *fillLayer;
@end

@implementation BTView
- (void)setUpDisplay {
    [self setUpLayers];
    [self refreshDisplayBTView];
}

- (void)setUpDefault {
    // Set up default
    self.roundAsMuchAsPossible = NO;
    self.roundedAllCorners = YES;
}

- (void)setUpLayers {
    {
        if (self.fillLayer != nil) {
            [self.fillLayer removeFromSuperlayer];
        }
        CAShapeLayer *fillLayerNormal = [CAShapeLayer layer];
        [self.layer insertSublayer:fillLayerNormal atIndex:0];
        self.fillLayer = fillLayerNormal;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setUpDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshDisplayBTView];
}

- (CGFloat)lineWidthForDrawingRect:(CGRect)rect {
    CGFloat lineWidth = self.lineWidth;
    if (lineWidth > MIN(rect.size.width, rect.size.height)/6.0f) {
        lineWidth = MIN(rect.size.width, rect.size.height)/6.0f;
    }
    return lineWidth;
}

- (CGFloat)cornerRadiusForRect:(CGRect)rect {
    CGFloat radius;
    if (self.roundAsMuchAsPossible) {
        radius = rect.size.height / 2;
    } else {
        radius = self.cornerRadius;
    }
    return radius;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    [self layoutCustomLayers];
}

- (void)updateLayer:(CAShapeLayer *)layer rect:(CGRect)rect withStrokeColor:(UIColor *)strokeColor {
    CGFloat radius = [self cornerRadiusForRect:rect];
    CGFloat lineWidth = [self lineWidthForDrawingRect:rect];
    if (rect.size.width > 4 && rect.size.height > 4) {
        UIRectCorner corners;
        if (self.roundedAllCorners) {
            corners = UIRectCornerAllCorners;
        } else {
            corners = 0;
            
            if (self.roundedTopLeft) {
                corners = corners | UIRectCornerTopLeft;
            }
            
            if (self.roundedTopRight) {
                corners = corners | UIRectCornerTopRight;
            }
            
            if (self.roundedBottomLeft) {
                corners = corners | UIRectCornerBottomLeft;
            }
            
            if (self.roundedBottomRight) {
                corners = corners | UIRectCornerBottomRight;
            }
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        layer.path = path.CGPath;
        
        layer.strokeColor = strokeColor.CGColor;
        layer.lineWidth = lineWidth * [UIScreen mainScreen].scale;
        
        layer.fillColor = [UIColor clearColor].CGColor;
        
        layer.frame = rect;
    }
}

- (void)updateMaskLayerWithRect:(CGRect)rect {
    CGFloat radius = [self cornerRadiusForRect:rect];
    if (rect.size.width > 4 && rect.size.height > 4) {
        CAShapeLayer *shape = [CAShapeLayer layer];
        UIRectCorner corners;
        if (self.roundedAllCorners) {
            corners = UIRectCornerAllCorners;
        } else {
            corners = 0;
            
            if (self.roundedTopLeft) {
                corners = corners | UIRectCornerTopLeft;
            }
            
            if (self.roundedTopRight) {
                corners = corners | UIRectCornerTopRight;
            }
            
            if (self.roundedBottomLeft) {
                corners = corners | UIRectCornerBottomLeft;
            }
            
            if (self.roundedBottomRight) {
                corners = corners | UIRectCornerBottomRight;
            }
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        shape.path = path.CGPath;
        self.layer.mask = shape;
    }
}

- (void)refreshDisplayBTViewInRect:(CGRect)rect {
    [self updateLayer:self.fillLayer rect:rect withStrokeColor:self.strokeColor];
}

- (void)setRoundedTopLeft:(BOOL)roundedTopLeft {
    _roundedTopLeft = roundedTopLeft;
    [self refreshDisplayBTView];
}

- (void)setRoundedTopRight:(BOOL)roundedTopRight {
    _roundedTopRight = roundedTopRight;
    [self refreshDisplayBTView];
}

- (void)setRoundedBottomLeft:(BOOL)roundedBottomLeft {
    _roundedBottomLeft = roundedBottomLeft;
    [self refreshDisplayBTView];
}

- (void)setRoundedBottomRight:(BOOL)roundedBottomRight {
    _roundedBottomRight = roundedBottomRight;
    [self refreshDisplayBTView];
}

- (void)setRoundedAllCorners:(BOOL)roundedAllCorners {
    _roundedAllCorners = roundedAllCorners;
    [self refreshDisplayBTView];
}

- (void)refreshDisplayBTView {
    BOOL backupValue = [CATransaction disableActions];
    [CATransaction setDisableActions:YES];
    [self updateMaskLayerWithRect:self.bounds];
    [self layoutCustomLayers];
    [CATransaction setDisableActions:backupValue];
}

- (void)layoutCustomLayers {
    [self removeAndReaddLayers];
    [self refreshDisplayBTViewInRect:self.bounds];
}

- (void)removeAndReaddLayers {
    {
        [self.fillLayer removeFromSuperlayer];
        [self.layer insertSublayer:self.fillLayer atIndex:0];
    }
}
@end
