//
//  ChildListStaticBubbleViewManager.m
//  mycle
//
//  Created by Hien Pham on 2/12/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ChildListStaticBubbleViewManager.h"
#import "BubbleView.h"

@interface StaticBubbleViewInfo : NSObject
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat alpha;
@end

@implementation StaticBubbleViewInfo
- (instancetype)initWithPosition:(CGPoint)position scale:(CGFloat)scale alpha:(CGFloat)alpha
{
    self = [super init];
    if (self) {
        self.position = position;
        self.scale = scale;
        self.alpha = alpha;
    }
    return self;
}

+ (StaticBubbleViewInfo *)staticBubbleViewInfoWithPosition:(CGPoint)position scale:(CGFloat)scale alpha:(CGFloat)alpha {
    StaticBubbleViewInfo *staticBubbleViewInfo = [[StaticBubbleViewInfo alloc] initWithPosition:position scale:scale alpha:alpha];
    return staticBubbleViewInfo;
}
@end

@implementation ChildListStaticBubbleViewManager {
    NSMutableArray<BubbleView *> *bubbleViews;
    NSMutableArray<UIView *> *decorationViews;
}
static CGFloat const MAX_GRID_ROW = 23;
static CGFloat const MAX_GRID_COLUMN = 18;
static CGFloat const STATIC_MAX_NUMBER_OF_DECORATIONS = 15;

- (NSInteger)numberOfBubbles {
    if ([self.dataSource respondsToSelector:@selector(numberOfBubblesInChildList:)]) {
        NSInteger numberOfBubbles = [self.dataSource numberOfBubblesInChildList:self];
        return numberOfBubbles;
    } else {
        return 0;
    }
}

- (void)reloadData {
    [self removeAllBubbleViews];
    NSInteger numberOfBubbles = MIN(self.numberOfBubbles, STATIC_MAX_NUMBER_OF_PATTERNS);
    NSArray<StaticBubbleViewInfo *> *patterns = [self generateBubblePatterns];
    for (NSInteger index = 0; index < numberOfBubbles; index++) {
        BubbleView *bubble = [self.dataSource childListBubbleViewManager:self bubbleViewForItemAtIndex:index];
        bubble.tag = index;
        [bubbleViews addObject:bubble];
        StaticBubbleViewInfo *info = patterns[index];
        [bubble setupLayoutInView:self.scrollView withPoint:info.position];
        [bubble startStaticAnimation];
        bubble.transform = CGAffineTransformMakeScale(info.scale, info.scale);
        bubble.alpha = info.alpha;
    }
    
    NSArray<StaticBubbleViewInfo *> *decorations = [self generateDecorationPatterns];
    for (StaticBubbleViewInfo *info in decorations) {
        UIView *decorationView = [BubbleView createDecorationView];
        [BubbleView setupLayoutForDecorationView:decorationView inView:self.scrollView withPoint:info.position];
        decorationView.transform = CGAffineTransformMakeScale(info.scale, info.scale);
        decorationView.alpha = info.alpha;
        [decorationViews addObject:decorationView];
    }
}

- (void)removeAllBubbleViews {
    for (UIView *view in bubbleViews) {
        [view removeFromSuperview];
    }
    [bubbleViews removeAllObjects];
    for (UIView *view in decorationViews) {
        [view removeFromSuperview];
    }
    [decorationViews removeAllObjects];
    
    if (bubbleViews == nil) {
        bubbleViews = [NSMutableArray array];
    }
    if (decorationViews == nil) {
        decorationViews = [NSMutableArray array];
    }
}

- (CGSize)calculateContentSize {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.scrollView.bounds.size.height;
    CGSize contentSize = CGSizeMake(width, height);
    return contentSize;
}

- (NSArray<StaticBubbleViewInfo *> *)generateBubblePatterns {
    NSMutableArray<StaticBubbleViewInfo *> *patterns = [NSMutableArray array];
    for (int i = 0; i < STATIC_MAX_NUMBER_OF_PATTERNS; i++) {
        CGPoint gridPoint;
        CGFloat scale;
        CGFloat alpha;
        switch (i) {
            case 0: {
                gridPoint = CGPointMake(2, 1);
                scale = 0.9;
                alpha = 0.9;
                break;
            }
            case 1: {
                gridPoint = CGPointMake(2, 8);
                scale = 0.8;
                alpha = 0.8;
                break;
            }
            case 2: {
                gridPoint = CGPointMake(9, 10);
                scale = 0.8;
                alpha = 0.8;
                break;
            }
            case 3: {
                gridPoint = CGPointMake(11, 1);
                scale = 0.8;
                alpha = 0.8;
                break;
            }
            case 4: {
                gridPoint = CGPointMake(7, 6.5);
                scale = 0.6;
                alpha = 0.6;
                break;
            }
            case 5: {
                gridPoint = CGPointMake(5, 5);
                scale = 0.4;
                alpha = 0.5;
                break;
            }
            case 6:
            default: {
                gridPoint = CGPointMake(7, 3);
                scale = 0.6;
                alpha = 0.6;
                break;
            }
        }
        CGPoint point = CGPointMake(gridPoint.x * self.gridColumnWidth,
                                    gridPoint.y * self.gridRowHeight);
        StaticBubbleViewInfo *info = [[StaticBubbleViewInfo alloc] initWithPosition:point scale:scale alpha:alpha];
        [patterns addObject:info];
    }
    
    return patterns;
}

- (NSArray<StaticBubbleViewInfo *> *)generateDecorationPatterns {
    NSMutableArray<StaticBubbleViewInfo *> *patterns = [NSMutableArray array];
    
    // Generate fixed decoration patterns
    for (int i = 0; i < STATIC_MAX_NUMBER_OF_DECORATIONS; i++) {
        CGPoint gridPoint;
        CGFloat scale;
        CGFloat alpha;
        switch (i) {
            case 0: {
                gridPoint = CGPointMake(1.5, -2);
                scale = 0.05;
                alpha = 0.25;
                break;
            }
            case 1: {
                gridPoint = CGPointMake(4, -1.5);
                scale = 0.1;
                alpha = 0.25;
                break;
            }
            case 2: {
                gridPoint = CGPointMake(9, 0);
                scale = 0.05;
                alpha = 0.25;
                break;
            }
            case 3: {
                gridPoint = CGPointMake(0, 0.5);
                scale = 0.1;
                alpha = 0.2;
                break;
            }
            case 4: {
                gridPoint = CGPointMake(5, 3.5);
                scale = 0.025;
                alpha = 0.15;
                break;
            }
            case 5: {
                gridPoint = CGPointMake(4.5, 4);
                scale = 0.025;
                alpha = 0.2;
                break;
            }
            case 6: {
                gridPoint = CGPointMake(5, 4.5);
                scale = 0.025;
                alpha = 0.15;
                break;
            }
            case 7: {
                gridPoint = CGPointMake(1.5, 6);
                scale = 0.05;
                alpha = 0.25;
                break;
            }
            case 8: {
                gridPoint = CGPointMake(9, 8.75);
                scale = 0.05;
                alpha = 0.25;
                break;
            }
            case 9: {
                gridPoint = CGPointMake(13, 10);
                scale = 0.2;
                alpha = 0.25;
                break;
            }
            case 10: {
                gridPoint = CGPointMake(14, 12);
                scale = 0.05;
                alpha = 0.25;
                break;
            }
            default: {
                gridPoint = CGPointMake(-3, 13);
                scale = 0.2;
                alpha = 0.1;
                break;
            }
        }
        CGPoint point = CGPointMake(gridPoint.x * self.gridColumnWidth,
                                    gridPoint.y * self.gridRowHeight);
        StaticBubbleViewInfo *info = [[StaticBubbleViewInfo alloc] initWithPosition:point scale:scale alpha:alpha];
        [patterns addObject:info];
    }
    
    // Generate dynamic decoration patterns
    for (int i = 0; i < 16; i++) {
        CGFloat gridPointX = [ChildListStaticBubbleViewManager randomFloatBetween:-3 maxNumber:14];
        CGFloat gridPointY = [ChildListStaticBubbleViewManager randomFloatBetween:0 maxNumber:14];
        CGFloat scale = [ChildListStaticBubbleViewManager randomFloatBetween:0.0 maxNumber:0.3];
        CGFloat alpha = [ChildListStaticBubbleViewManager randomFloatBetween:0.0 maxNumber:0.2];
        CGPoint point = CGPointMake(gridPointX * self.gridColumnWidth,
                                    gridPointY * self.gridRowHeight);
        StaticBubbleViewInfo *info = [[StaticBubbleViewInfo alloc] initWithPosition:point scale:scale alpha:alpha];
        [patterns addObject:info];
    }
    
    return patterns;
}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random() % (max - min);
}

+ (CGFloat)randomFloatBetween:(CGFloat)smallNumber maxNumber:(CGFloat)bigNumber {
    CGFloat diff = bigNumber - smallNumber;
    return (((CGFloat) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (CGFloat)gridColumnWidth {
    return [UIScreen mainScreen].bounds.size.width / MAX_GRID_COLUMN;
}

- (CGFloat)gridRowHeight {
    return [UIScreen mainScreen].bounds.size.height / MAX_GRID_ROW;
}

- (NSInteger)currentNumberOfBubbleViews {
    return bubbleViews.count;
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.currentNumberOfBubbleViews) {
        return bubbleViews[index];
    } else {
        return nil;
    }
}
@end

