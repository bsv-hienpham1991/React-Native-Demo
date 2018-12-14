//
//  ListStaticBubbleView.h
//  mycle
//
//  Created by Hien Pham on 3/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListBubbleView.h"

@interface ListStaticBubbleView : UIScrollView
@property (strong, nonatomic) IBOutlet ListBubbleView *parent;
- (void)reloadData;
- (void)removeAllBubbleViews;
- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index;
@end
