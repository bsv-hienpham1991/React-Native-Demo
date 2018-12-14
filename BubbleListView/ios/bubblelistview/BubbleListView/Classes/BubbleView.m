//
//  BubbleView.m
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "BubbleView.h"
#import "BTView.h"
#import "PureLayout.h"

@interface BubbleView() <CAAnimationDelegate, MyFaveButtonDelegate>
@property (weak, nonatomic) NSTimer *animationTimer;
@property (nonatomic, weak) IBOutlet MyFaveButton *myFaveButton;

@end

@implementation BubbleView {
    CGFloat timeOffSet;
    BOOL didSetUpDynamicAnimation;
    BOOL didSetUpStaticAnimation;
    BOOL stopAnimateContentViewFadeIn;
}
static const CGFloat DURATION = 2;
static const NSInteger MAX_DURATION = 8;

+ (UIView *)createDecorationView {
    BTView *decorationView = [BTView new];
    decorationView.backgroundColor = [UIColor whiteColor];
    decorationView.roundAsMuchAsPossible = YES;
    decorationView.clipsToBounds = YES;
    return decorationView;
}

+ (void)setupLayoutForDecorationView:(UIView *)decorationView inView:(UIView *)inView withPoint:(CGPoint)point {
    [inView addSubview:decorationView];
    [decorationView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:point.x];
    [decorationView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:point.y];
    [decorationView autoSetDimensionsToSize:CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE)];
    [inView layoutIfNeeded];
}

- (void)setupLayoutInView:(UIView *)inView withPoint:(CGPoint)point {
    [inView addSubview:self];
    [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:point.x];
    [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:point.y];
    [self autoSetDimensionsToSize:CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE)];
    self.point = point;
    [inView layoutIfNeeded];
}

- (void)setUpAnimationWithDelay:(NSInteger)delay {
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startDynamicAnimation];
    });
}

- (void)startDynamicAnimation {
    timeOffSet = 0.0;
    stopAnimateContentViewFadeIn = NO;
    CGSize size = CGSizeMake(BUBBLE_SIZE * 2, BUBBLE_SIZE * 2);
    [self setupAnimationInLayer:self.layer withSize:size tintColor:[UIColor whiteColor]];
}

- (void)startStaticAnimation {
    CGSize size = CGSizeMake(BUBBLE_SIZE * 2, BUBBLE_SIZE * 2);
    [self setupStaticAnimationInLayer:self.layer withSize:size tintColor:[UIColor whiteColor]];
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    if (!didSetUpDynamicAnimation) {
        // Scale animation
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = DURATION;
        scaleAnimation.fromValue = @0.5f;
        scaleAnimation.toValue = @1.0f;
        
        // Opacity animation
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        
        opacityAnimation.duration = DURATION;
        opacityAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
        opacityAnimation.values = @[@1.0f, @0.5f, @0.0f];
        
        // Animation
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        
        animation.animations = @[scaleAnimation, opacityAnimation];
        animation.duration = DURATION;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.removedOnCompletion = NO;
        
        // Draw circle
        [self layoutIfNeeded];
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
        
        circle.fillColor = nil;
        circle.lineWidth = 2;
        circle.strokeColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
        [layer addSublayer:circle];
        didSetUpDynamicAnimation = YES;
    }
    
    [self animateContentViewFadeInAnimationWithTimeOffset:0.0];
}

- (void)setupStaticAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    if (!didSetUpStaticAnimation) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
        
        circle.fillColor = nil;
        circle.lineWidth = 2;
        circle.strokeColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
        circle.affineTransform = CGAffineTransformMakeScale(0.54, 0.54);
        circle.opacity = 0.5;
        
        [layer addSublayer:circle];
        didSetUpStaticAnimation = YES;
    }
}

- (void)animateContentViewFadeInAnimationWithTimeOffset:(CFTimeInterval)timeOffSet {
    if (stopAnimateContentViewFadeIn) {
        return;
    }
    [CATransaction begin];
    // Scale animation
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = MAX_DURATION;
    scaleAnimation.keyTimes = @[@0.0f, @0.7f, @1.0f];
    scaleAnimation.values = @[@0.2f, @1.0f, @1.0f];
    
    // Opacity animation
    CAKeyframeAnimation *fadeInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = MAX_DURATION;
    fadeInAnimation.keyTimes = @[@0.0f, @0.7f, @1.0f];
    fadeInAnimation.values = @[@0.0f, @1.0f, @0.0f];
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, fadeInAnimation];
    animation.duration = MAX_DURATION;
    animation.delegate = self;
    animation.beginTime = CACurrentMediaTime() - timeOffSet;
    [animation setValue:@"animation_group" forKey:@"animation"];
    [self.layer addAnimation:animation forKey:@"contentViewFadeInAnimation"];
    [CATransaction commit];
}

#pragma mark - CAAnimation Delagate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animation"] isEqualToString:@"animation_group"]) {
        if (stopAnimateContentViewFadeIn) {
            return;
        }
        if (flag) {
            [self.animationTimer invalidate];
            [self removeFromSuperview];
            [self.bubbleViewDelegate bubbleView:self didCloseWithPoint:self.point];
        }
    } else if ([[anim valueForKey:@"animation"] isEqualToString:@"selected_complete"]) {
        [self.animationTimer invalidate];
        [self removeFromSuperview];
        [self.bubbleViewDelegate bubbleViewDidSelect:self];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleTap:(UITapGestureRecognizer *)recognizer completion:(void (^)(BOOL))completion {
    CGFloat scaleRatio = self.layer.presentationLayer.frame.size.width / self.layer.frame.size.width;
    BOOL canHandleTap = NO;
    if (scaleRatio < 1) {
        canHandleTap = scaleRatio >= 0.2 && self.layer.presentationLayer.opacity >= 0.2;
    } else {
        canHandleTap = self.layer.presentationLayer.opacity >= 0.4;
    }
    if (self.myFaveButton.isUserInteractionEnabled && canHandleTap ) {
        [self.myFaveButton setSelected:YES];
        completion(YES);
    } else {
        completion(NO);
    }
}


#pragma mark - MyFaveButton

- (void)myFaveButton:(MyFaveButton *)myFaveButton didSelected:(BOOL)selected {
    myFaveButton.userInteractionEnabled = YES;
}

- (void)myFaveButton:(nullable MyFaveButton *)myFaveButton willAnimateSelected:(BOOL)selected {
    myFaveButton.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    stopAnimateContentViewFadeIn = YES;
    CGFloat scale = [[self.layer.presentationLayer valueForKeyPath:@"transform.scale"] floatValue];
    CGFloat opacity = self.layer.presentationLayer.opacity;
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.layer.opacity = opacity;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Opacity animation
        CGFloat opacity = weakSelf.layer.presentationLayer.opacity;
        weakSelf.layer.opacity = 0.0f;
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation.duration = 0.25f;
        fadeInAnimation.fromValue = @(opacity);
        fadeInAnimation.delegate = self;
        [fadeInAnimation setValue:@"selected_complete" forKey:@"animation"];
        [weakSelf.layer addAnimation:fadeInAnimation forKey:nil];
    });
}

- (UIView *)touchView {
    return self.myFaveButton;
}

-(void)bubbleViewPauseAnimation {
    self.layer.speed = 0.0;
    CAAnimation *contentViewFadeInAnimation = [self.layer animationForKey:@"contentViewFadeInAnimation"];
    timeOffSet = CACurrentMediaTime() - contentViewFadeInAnimation.beginTime;
}

-(void)bubbleViewResumeAnimation {
    if (timeOffSet == 0.0) {
        return;
    }
    self.layer.speed = 1.0;
    [self animateContentViewFadeInAnimationWithTimeOffset:timeOffSet];
}

@end
