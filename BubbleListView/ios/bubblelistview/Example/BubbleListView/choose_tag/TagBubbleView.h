//
//  TagBubbleView.h
//  mycle
//
//  Created by Hien Pham on 2/6/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "BubbleView.h"

@interface TagBubbleView : BubbleView
@property (strong, nonatomic) IBOutlet UILabel *symbolLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagUseCountLabel;
@end
