//
//  ChildChildListBubbleViewManagerManager.h
//  mycle
//
//  Created by Hien Pham on 2/9/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BubbleView;
@class ChildListBubbleViewManager;
@protocol ChildListBubbleViewManagerDataSource<NSObject>
@required
- (NSInteger)numberOfBubblesInChildList:(ChildListBubbleViewManager *)childListBubbleViewManager;
- (BubbleView *)childListBubbleViewManager:(ChildListBubbleViewManager *)childListBubbleViewManager bubbleViewForItemAtIndex:(NSInteger)index;
@end

@protocol ChildListBubbleViewManagerDelegate<NSObject>
@optional
- (void)childListBubbleViewManager:(ChildListBubbleViewManager *)childListBubbleViewManager didSelectAtIndex:(NSInteger)index;
@end

@interface ChildListBubbleViewManager : NSObject
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (weak, nonatomic, readonly) id<ChildListBubbleViewManagerDataSource> dataSource;
@property (weak, nonatomic, readonly) id<ChildListBubbleViewManagerDelegate> delegate;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView dataSourceAndDelegate:(id<ChildListBubbleViewManagerDataSource, ChildListBubbleViewManagerDelegate>)dataSourceAndDelegate;
- (NSInteger)numberOfBubbles;
- (void)reloadData;
- (CGSize)calculateContentSize;
 -(void)removeAllBubbleViews;
- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index;
@end
