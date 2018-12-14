//
//  ChildListDynamicBubbleViewManager.h
//  mycle
//
//  Created by Hien Pham on 2/12/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildListBubbleViewManager.h"
#import "ListDynamicBubbleView.h"

static NSInteger const DYNAMIC_MAX_NUMBER_OF_BUBBLES = 10;

@class ChildListDynamicBubbleViewManager;
@class BubbleView;
@protocol ChildListDynamicBubbleViewManagerDelegate<NSObject>
- (void)childListDynamicBubbleViewManagerDidCloseBubbleView:(ChildListDynamicBubbleViewManager *)childListDynamicBubbleViewManager;
- (void)childListDynamicBubbleViewManager:(ChildListDynamicBubbleViewManager *)childListDynamicBubbleViewManager didRemoveBubbleViewAtIndex:(NSInteger)index;
@end

@interface ChildListDynamicBubbleViewManager : ChildListBubbleViewManager
@property (strong, nonatomic) ListDynamicBubbleView *parent;
@property (weak, nonatomic) id<ChildListDynamicBubbleViewManagerDelegate> listDynamicManagerDelegate;
@property (assign, nonatomic) CGFloat startYPosition;
- (void)insertBubblesWithCount:(NSInteger)count;
- (NSInteger)currentNumberOfBubbleViews;
- (void)moveItemAtIndexToLastPosition:(NSInteger)index;
- (void)pauseAnimation;
- (void)resumeAnimation;
@end
