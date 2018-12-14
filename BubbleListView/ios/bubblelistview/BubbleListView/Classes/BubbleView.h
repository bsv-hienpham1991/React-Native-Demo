//
//  BubbleView.h
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFaveButton.h"

@class BubbleView;
@protocol BubbleViewDelegate<NSObject>
@optional
- (void)bubbleView:(BubbleView *)bubbleView didCloseWithPoint:(CGPoint)point;
- (void)bubbleViewDidSelect:(BubbleView *)bubbleView;
@end

static const CGFloat BUBBLE_SIZE = 125;

@interface BubbleView : UIView<MyFaveButtonDelegate>
@property (weak, nonatomic) id<BubbleViewDelegate> bubbleViewDelegate;
@property (nonatomic, assign) CGPoint point;

+ (BubbleView *)createDecorationView;
+ (void)setupLayoutForDecorationView:(UIView *)decorationView inView:(UIView *)inView withPoint:(CGPoint)point;
- (void)setupLayoutInView:(UIView *)inView withPoint: (CGPoint)point;
- (void)setUpAnimationWithDelay:(NSInteger)delay;
- (void)handleTap:(UITapGestureRecognizer *)recognizer completion:(void (^)(BOOL canTap))completion;
- (UIView *)touchView;

/**
 * start animation
 */
- (void)startDynamicAnimation;
- (void)startStaticAnimation;

- (void)bubbleViewPauseAnimation;
- (void)bubbleViewResumeAnimation;

@end
