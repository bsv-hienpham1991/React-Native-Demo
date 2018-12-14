//
//  ListStaticBubbleView.m
//  mycle
//
//  Created by Hien Pham on 3/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ListStaticBubbleView.h"
#import "ChildListStaticBubbleViewManager.h"

@interface ListStaticBubbleView()<ChildListBubbleViewManagerDataSource, ChildListBubbleViewManagerDelegate>
@property (strong, nonatomic) ChildListStaticBubbleViewManager *manager;
@end

@implementation ListStaticBubbleView
-(void)removeAllBubbleViews {
    [self.manager removeAllBubbleViews];
}

- (void)reloadData {
    [self removeAllBubbleViews];
    NSAssert(self.parent.numberOfBubbles >= 0, @"Inserted count must be larger or equal 0");
    ChildListStaticBubbleViewManager *manager = [[ChildListStaticBubbleViewManager alloc] initWithScrollView:self dataSourceAndDelegate:self];
    [manager reloadData];
    self.manager = manager;
    [self updateContentSize];
}

- (void)updateContentSize {
    CGSize contentSize = [self.manager calculateContentSize];
    self.contentSize = contentSize;
}

- (NSInteger)numberOfBubblesInChildList:(ChildListBubbleViewManager *)childListBubbleViewManager {
    NSInteger numberOfBubblesInChildList = self.parent.numberOfBubbles;
    return numberOfBubblesInChildList;
}

- (BubbleView *)childListBubbleViewManager:(ChildListBubbleViewManager *)childListBubbleViewManager bubbleViewForItemAtIndex:(NSInteger)index {
    BubbleView *bubbleView = [self.parent.dataSource listBubbleView:self.parent bubbleViewForItemAtIndex:index];
    return bubbleView;
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    return [self.manager bubbleViewForItemAtIndex:index];
}
@end
