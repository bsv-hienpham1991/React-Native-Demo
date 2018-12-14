//
//  TagBubbleView.m
//  mycle
//
//  Created by Hien Pham on 2/6/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "TagBubbleView.h"
#import "MyFaveButton.h"

@interface TagBubbleView()
@end

@implementation TagBubbleView
- (void)awakeFromNib {
    [super awakeFromNib];
}

//- (void)myFaveButton:(MyFaveButton *)myFaveButton didSelected:(BOOL)selected {
//}
//
//- (void)myFaveButton:(nullable MyFaveButton *)myFaveButton willAnimateSelected:(BOOL)selected {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.alpha = 0;
//        } completion:^(BOOL finished) {
//        }];
//    });
//    if (selected == true) {
//        self.symbolLabel.textColor = [UIColor grayColor];
//        self.tagNameLabel.textColor = [UIColor whiteColor];
//        self.tagUseCountLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.symbolLabel.textColor = [UIColor orangeColor];
//        self.tagNameLabel.textColor = [UIColor blackColor];
//        self.tagUseCountLabel.textColor = [UIColor blackColor];
//    }
//}
@end
