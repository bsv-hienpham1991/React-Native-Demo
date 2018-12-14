//
//  RegisterMycleChooseTagViewController.h
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

@import UIKit;

typedef enum : NSUInteger {
    ChooseTagTypeDelete = 0,
    ChooseTagTypeGoToAnotherScreen,
    ChooseTagTypeStatic,
} ChooseTagType;

@interface ChooseTagViewController : UIViewController
- (instancetype)initWithChooseTagType:(ChooseTagType)type;
@end
