//
//  RNTBubbleListViewManager.m
//  RNBubbleListView
//
//  Created by Hien Pham on 12/3/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNTBubbleListViewManager.h"
#import "ListBubbleView.h"

@implementation RNTBubbleListViewManager
RCT_EXPORT_MODULE()
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (UIView *)view {
    return [[ListBubbleView alloc] init];
}
@end
