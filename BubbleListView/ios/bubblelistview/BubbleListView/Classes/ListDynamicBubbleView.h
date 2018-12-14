//
//  ListDynamicBubbleView.h
//  mycle
//
//  Created by Hien Pham on 3/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListBubbleView.h"
@class ChildListDynamicBubbleViewManager;
@interface ListDynamicBubbleView : UIScrollView
@property (strong, nonatomic) IBOutlet ListBubbleView *parent;
- (void)reloadData;
- (void)insertBubblesWithCount:(NSInteger)count;
-(void)removeAllBubbleViews;
- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index;
- (void)notifyDeleteItemEvent;
- (void)deleteItemAtIndex:(NSInteger)deletedIndex;
- (BOOL)isLastManager:(ChildListDynamicBubbleViewManager *)manager;
- (NSIndexPath *)indexPathFromRealIndex:(NSInteger)realIndex;

- (void)pauseAnimation;
- (void)resumeAnimation;

@end
