//
//  ChildListBubbleViewManager.m
//  mycle
//
//  Created by Hien Pham on 2/9/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ChildListBubbleViewManager.h"

@interface ChildListBubbleViewManager()
@end

@implementation ChildListBubbleViewManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView dataSourceAndDelegate:(id<ChildListBubbleViewManagerDataSource, ChildListBubbleViewManagerDelegate>)dataSourceAndDelegate
{
    self = [self init];
    if (self) {
        _scrollView = scrollView;
        _dataSource = dataSourceAndDelegate;
        _delegate = dataSourceAndDelegate;
    }
    return self;
}

- (NSInteger)numberOfBubbles {
    @throw @"Please override and implement thid method.";
}

- (void)reloadData {
    @throw @"Please override and implement thid method.";
}

- (CGSize)calculateContentSize {
    @throw @"Please override and implement thid method.";
}

-(void)removeAllBubbleViews {
    @throw @"Please override and implement thid method.";
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    @throw @"Please override and implement thid method.";
}
@end
