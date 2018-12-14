//
//  BetterButton.m
//  netstation_aplus
//
//  Created by HIEN DEP TRAI on 2/8/17.
//  Copyright © 2017 HIEN PHAM. All rights reserved.
//

#import "BTButton.h"
#import "UIColor+DarkerColor.h"
@interface BTButton()
@property (strong, nonatomic) CAShapeLayer *fillLayer;
@end
@implementation BTButton
- (void)setUpDisplay {
    [self setUpLayers];
    [self refreshDisplayBTButton];
}

- (void)setUpDefault {
    // Set up default
    self.roundAsMuchAsPossible = NO;
    self.highlightedEnabled = YES;
    self.roundedAllCorners = YES;
}

- (void)setUpLayers {
    {
        if (self.fillLayer != nil) {
            [self.fillLayer removeFromSuperlayer];
        }
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:fillLayer atIndex:0];
        self.fillLayer = fillLayer;
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
    [self refreshDisplayBTButton];
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
    if (self.fillLayer != nil) {
        [self.fillLayer removeFromSuperlayer];
        [self.layer insertSublayer:self.fillLayer atIndex:0];
    }
}

- (void)updateLayer:(CAShapeLayer *)layer rect:(CGRect)rect withFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor {
    CGFloat radius = [self cornerRadiusForRect:rect];
    CGFloat lineWidth = [self lineWidthForDrawingRect:rect];
    if ((rect.size.width > 4 && rect.size.height > 4 && radius > 0) || radius <= 0) {
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
        
        layer.fillColor = fillColor.CGColor;
        
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

- (void)refreshDisplayBTButtonInRect:(CGRect)rect {
    UIColor *fillColor;
    UIColor *strokeColor;
    if (self.state & UIControlStateDisabled) {
        fillColor = self.fillColorDisabled;
        strokeColor = self.strokeColorDisabled;
    } else if (self.state & UIControlStateSelected) {
        fillColor = self.fillColorSelected;
        strokeColor = self.strokeColorSelected;
    } else if (self.state & UIControlStateHighlighted) {
        fillColor = self.fillColorHighlighted == nil ? self.fillColorNormal.darkerColor : self.fillColorHighlighted;
        strokeColor = self.strokeColorHighlighted == nil ? self.strokeColorNormal.darkerColor : self.strokeColorHighlighted;
    } else {
        fillColor = self.fillColorNormal;
        strokeColor = self.strokeColorNormal;
    }
    [self updateLayer:self.fillLayer rect:rect withFillColor:fillColor withStrokeColor:strokeColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self refreshDisplayBTButton];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refreshDisplayBTButton];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self refreshDisplayBTButton];
}

- (void)setFillColorNormal:(UIColor *)fillColorNormal {
    _fillColorNormal = fillColorNormal;
    [self refreshDisplayBTButton];
}

- (void)setFillColorHighlighted:(UIColor *)fillColorHighlighted {
    _fillColorHighlighted = fillColorHighlighted;
    [self refreshDisplayBTButton];
}

- (void)setFillColorSelected:(UIColor *)fillColorSelected {
    _fillColorSelected = fillColorSelected;
    [self refreshDisplayBTButton];
}

- (void)setFillColorDisabled:(UIColor *)fillColorDisabled {
    _fillColorDisabled = fillColorDisabled;
    [self refreshDisplayBTButton];
}

- (void)setRoundedTopLeft:(BOOL)roundedTopLeft {
    _roundedTopLeft = roundedTopLeft;
    [self refreshDisplayBTButton];
}

- (void)setRoundedTopRight:(BOOL)roundedTopRight {
    _roundedTopRight = roundedTopRight;
    [self refreshDisplayBTButton];
}

- (void)setRoundedBottomLeft:(BOOL)roundedBottomLeft {
    _roundedBottomLeft = roundedBottomLeft;
    [self refreshDisplayBTButton];
}

- (void)setRoundedBottomRight:(BOOL)roundedBottomRight {
    _roundedBottomRight = roundedBottomRight;
    [self refreshDisplayBTButton];
}

- (void)setRoundedAllCorners:(BOOL)roundedAllCorners {
    _roundedAllCorners = roundedAllCorners;
    [self refreshDisplayBTButton];
}

- (void)refreshDisplayBTButton {
    BOOL backupValue = [CATransaction disableActions];
    [CATransaction setDisableActions:YES];
    [self updateMaskLayerWithRect:self.bounds];
    [self refreshComponentsStates];
    [self layoutCustomLayers];
    [CATransaction setDisableActions:backupValue];
}

- (void)layoutCustomLayers {
    [self refreshDisplayBTButtonInRect:self.bounds];
}

- (void)refreshComponentsStates {
    for (UIButton *button in self.components) {
        button.highlighted = self.highlighted && self.highlightedEnabled;
        button.selected = self.selected;
        button.enabled = self.enabled;
    }
}
@end
