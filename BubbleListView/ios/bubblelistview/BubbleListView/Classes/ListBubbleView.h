//
//  BubbleView.h
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BubbleView;
@class ListBubbleView;
@protocol ListBubbleViewDataSource<NSObject>
@required
- (NSInteger)numberOfBubblesInListBubbleView:(ListBubbleView *)listBubbleView;
- (BubbleView *)listBubbleView:(ListBubbleView *)listBubbleView bubbleViewForItemAtIndex:(NSInteger)index;
@end

@protocol ListBubbleViewDelegate<NSObject>
@optional
- (void)listBubbleView:(ListBubbleView *)listBubbleView didSelectAtIndex:(NSInteger)index;
@end

@interface ListBubbleView : UIView
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL isStatic;
@property (assign, nonatomic) BOOL multiSelection;
@property (assign, nonatomic) BOOL needCacheAnimation;
@property (weak, nonatomic) id<ListBubbleViewDataSource> dataSource;
@property (weak, nonatomic) id<ListBubbleViewDelegate> delegate;
- (void)registerNib:(UINib *)nib forBubbleViewWithReuseIdentifier:(NSString *)identifier;
- (__kindof BubbleView *)dequeueReusableBubbleViewWithIdentifier:(NSString *)identifier;
- (NSInteger)numberOfBubbles;
- (void)reloadData;
- (void)insertBubblesWithCount:(NSInteger)count;
- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index;
- (void)deleteItemAtIndex:(NSInteger)deletedIndex;
@end
