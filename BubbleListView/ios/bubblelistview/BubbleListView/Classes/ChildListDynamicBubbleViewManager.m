//
//  ChildListDynamicBubbleViewManager.m
//  mycle
//
//  Created by Hien Pham on 2/12/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ChildListDynamicBubbleViewManager.h"
#import "BubbleView.h"

@interface ChildListDynamicBubbleViewManager()<BubbleViewDelegate>
@property (strong, atomic) NSMutableArray<BubbleView *> *bubbleViews;
@end

@implementation ChildListDynamicBubbleViewManager {
    NSMutableArray<NSValue *> *currentPoints;
    NSMutableArray<NSValue *> *queuePoints;
    NSDate *lastRenewTimeStamp;
}
static CGFloat const MAX_GRID_ROW = 23;
static CGFloat const MAX_GRID_COLUMN = 18;
static NSInteger const DYNAMIC_MAX_NUMBER_OF_PATTERNS = DYNAMIC_MAX_NUMBER_OF_BUBBLES + 2;
static CGFloat const BUBBLE_TIME_INTERVAL = 0.5;

- (instancetype)init
{
    self = [super init];
    if (self) {
        currentPoints = [NSMutableArray array];
        queuePoints = [NSMutableArray array];
        self.bubbleViews = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)numberOfBubbles {
    if ([self.dataSource respondsToSelector:@selector(numberOfBubblesInChildList:)]) {
        NSInteger numberOfBubbles = [self.dataSource numberOfBubblesInChildList:self];
        NSAssert(numberOfBubbles <= DYNAMIC_MAX_NUMBER_OF_BUBBLES, @"numberOfBubbles is invalid, because it is bigger than MAX_NUMBER_OF_BUBBLES");
        return numberOfBubbles;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfPatterns {
    return self.numberOfBubbles + 2;
}

- (void)reloadData {
    [self removeAllBubbleViews];
    [currentPoints removeAllObjects];
    [queuePoints removeAllObjects];
    [self insertBubblesWithCount:self.numberOfBubbles];
}


- (void)pauseAnimation {
    for (BubbleView *bubble in self.bubbleViews) {
        [bubble bubbleViewPauseAnimation];
    }
}

- (void)resumeAnimation {
    for (BubbleView *bubble in self.bubbleViews) {
        [bubble bubbleViewResumeAnimation];
    }
}


- (void)removeAllBubbleViews {
    for (UIView *view in self.bubbleViews) {
        [view removeFromSuperview];
    }
    [self.bubbleViews removeAllObjects];
}

- (CGSize)calculateContentSize {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSArray<NSValue *> *allAvailablePoints = [NSArray array];
    allAvailablePoints = [allAvailablePoints arrayByAddingObjectsFromArray:currentPoints];
    allAvailablePoints = [allAvailablePoints arrayByAddingObjectsFromArray:queuePoints];
    for (BubbleView *bubbleView in self.bubbleViews) {
        NSValue *pointValue = [NSValue valueWithCGPoint:bubbleView.point];
        if (![allAvailablePoints containsObject:pointValue]) {
            allAvailablePoints = [allAvailablePoints arrayByAddingObject:pointValue];
        }
    }
    allAvailablePoints = [allAvailablePoints sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGPoint point1 = obj1.CGPointValue;
        CGPoint point2 = obj2.CGPointValue;
        if (point1.y < point2.y) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];

    CGPoint lastPoint = allAvailablePoints.lastObject.CGPointValue;
    CGFloat height = lastPoint.y - self.startYPosition + BUBBLE_SIZE;
    CGSize contentSize = CGSizeMake(width, height);
    return contentSize;
}

- (void)insertBubblesWithCount:(NSInteger)count {
    NSArray<NSValue *> *bubblePatterns = [self generateBubblePatterns];
    NSMutableArray<NSValue *> *availablePoints = [NSMutableArray arrayWithArray:bubblePatterns];
    for (NSValue *value in currentPoints) {
        if ([availablePoints containsObject:value]) {
            [availablePoints removeObject:value];
        }
    }
    for (NSValue *value in queuePoints) {
        if (![availablePoints containsObject:value] &&
            ![currentPoints containsObject:value]) {
            [availablePoints addObject:value];
        }
    }
    
    NSMutableArray<NSValue *> *randomPoints = [NSMutableArray array];
    while (availablePoints.count > 0) {
        NSValue *value = [availablePoints objectAtIndex: [ChildListDynamicBubbleViewManager randomNumberBetween:0 maxNumber:availablePoints.count]];
        [availablePoints removeObject:value];
        [randomPoints addObject:value];
    }
    
    NSInteger numberOfBubbles = self.currentNumberOfBubbleViews;
    NSInteger maxDelay = 0;
    for (NSInteger index = 0; index < count; index++) {
        NSValue *value = randomPoints.firstObject;
        CGPoint point = [value CGPointValue];
        NSInteger realIndex = index + numberOfBubbles;
        if (realIndex >= self.numberOfBubbles) {
            break;
        }
        BubbleView *bubble = [self.dataSource childListBubbleViewManager:self bubbleViewForItemAtIndex:realIndex];
        bubble.bubbleViewDelegate = self;
        bubble.tag = realIndex;
        [self.bubbleViews addObject:bubble];
        CGFloat delay = (index % DYNAMIC_MAX_NUMBER_OF_PATTERNS) * BUBBLE_TIME_INTERVAL;
        [bubble setupLayoutInView:self.scrollView withPoint:point];
        [bubble setUpAnimationWithDelay:delay];
        maxDelay = delay;
        [currentPoints addObject:value];
        [randomPoints removeObject:value];
    }
    
    lastRenewTimeStamp = [[NSDate date] dateByAddingTimeInterval:maxDelay];
    
    queuePoints = randomPoints;
}

- (void)bubbleViewDidSelect:(BubbleView *)bubbleView {
    if ([self.delegate respondsToSelector:@selector(childListBubbleViewManager:didSelectAtIndex:)]) {
        NSInteger selectedIndex = [self.bubbleViews indexOfObject:bubbleView];
        NSInteger numberOfDeleletedItems = self.currentNumberOfBubbleViews - self.numberOfBubbles;
        selectedIndex -= numberOfDeleletedItems;
        if (selectedIndex >= 0 && selectedIndex < self.numberOfBubbles) {
            [self.delegate childListBubbleViewManager:self didSelectAtIndex:selectedIndex];
        }
    }
    [self bubbleView:bubbleView didCloseWithPoint:bubbleView.point];
}


- (void)bubbleView:(BubbleView *)bubbleView didCloseWithPoint:(CGPoint)point {
    NSValue *pointValue = [NSValue valueWithCGPoint: point];
    [currentPoints removeObject:pointValue];
    [queuePoints addObject:pointValue];
    NSInteger bubbleViewIndex = [self.bubbleViews indexOfObject:bubbleView];
    if (self.currentNumberOfPatterns > self.numberOfPatterns) {
        for (int i = 0; i < self.currentNumberOfPatterns - self.numberOfPatterns; i++) {
            NSArray<NSValue *> *currentPatterns = [self currentBubblePatternsWithSortAscendingXY:YES];
            NSValue *finalPattern = currentPatterns.lastObject;
            if ([queuePoints containsObject:finalPattern]) {
                [queuePoints removeObject:finalPattern];
            }
        }
        
        if (self.currentNumberOfBubbleViews > self.numberOfBubbles) {
            [self.bubbleViews removeObject:bubbleView];
            
            if ([self.listDynamicManagerDelegate respondsToSelector:@selector(childListDynamicBubbleViewManager:didRemoveBubbleViewAtIndex:)]) {
                [self.listDynamicManagerDelegate childListDynamicBubbleViewManager:self didRemoveBubbleViewAtIndex:bubbleViewIndex];
            }
        } else {
            [self renewBubblePointWithTimeIntervalForBubbleView:bubbleView];
        }
    } else {
        [self renewBubblePointWithTimeIntervalForBubbleView:bubbleView];
    }
    if ([self.listDynamicManagerDelegate respondsToSelector:@selector(childListDynamicBubbleViewManagerDidCloseBubbleView:)]) {
        [self.listDynamicManagerDelegate childListDynamicBubbleViewManagerDidCloseBubbleView:self];
    }
}

- (void)renewBubblePointWithTimeIntervalForBubbleView:(BubbleView *)bubbleView {
    NSDate *currentTimeStamp = [NSDate date];
    NSTimeInterval interval = [currentTimeStamp timeIntervalSinceDate:lastRenewTimeStamp];
    if (interval >= BUBBLE_TIME_INTERVAL && bubbleView.superview == nil) {
        lastRenewTimeStamp = currentTimeStamp;
        NSInteger index = [self.bubbleViews indexOfObject:bubbleView];
        NSInteger numberOfDeleletedItems = self.currentNumberOfBubbleViews - self.numberOfBubbles;
        index -= numberOfDeleletedItems;
        if (index >= 0 && index < self.numberOfBubbles) {
            [self renewBubblePointForItemAtIndex:index];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((BUBBLE_TIME_INTERVAL - interval) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf renewBubblePointWithTimeIntervalForBubbleView:bubbleView];
        });
    }
}

/**
 * renew point for bubble
 * @param index NSInteger
 */
- (void)renewBubblePointForItemAtIndex:(NSInteger)index {
    NSValue *value = [queuePoints objectAtIndex: [ChildListDynamicBubbleViewManager randomNumberBetween:0 maxNumber:queuePoints.count]];
    [queuePoints removeObject:value];
    [currentPoints addObject:value];
    CGPoint point = [value CGPointValue];
    BubbleView *bubble = [self.dataSource childListBubbleViewManager:self bubbleViewForItemAtIndex:index];
    bubble.bubbleViewDelegate = self;
    [bubble setupLayoutInView:self.scrollView withPoint:point];
    [bubble setUpAnimationWithDelay:0];
    [self.bubbleViews replaceObjectAtIndex:index withObject:bubble];
}

- (NSArray<NSValue *> *)generateBubblePatterns {
    NSAssert(self.numberOfPatterns <= DYNAMIC_MAX_NUMBER_OF_PATTERNS, @"Number of bubbles must be smaller than or equal %ld", DYNAMIC_MAX_NUMBER_OF_PATTERNS);
    NSArray<NSArray<NSNumber *> *> *patterns = @[
                                                 @[ @(-1),@(0) ] , @[ @(5),@(1) ], @[ @(11),@(0) ],
                                                 @[ @(0),@(6) ] , @[ @(6),@(7) ], @[ @(12),@(6) ],
                                                 @[ @(-1),@(12) ] , @[ @(6),@(13) ], @[ @(11),@(11) ],
                                                 @[ @(1),@(18) ] , @[ @(7),@(19) ], @[ @(12),@(17) ],
                                                 ];
    
    NSInteger numberOfPatternsToGenerate = MIN(self.numberOfPatterns, DYNAMIC_MAX_NUMBER_OF_PATTERNS);
    NSMutableArray<NSValue *> *bubblePatterns = [NSMutableArray array];
    for (int i = 0; i < numberOfPatternsToGenerate; i++) {
        CGPoint gridPoint = CGPointMake([patterns[i][0] floatValue], [patterns[i][1] floatValue]);
        CGPoint point = CGPointMake(gridPoint.x * self.gridColumnWidth,
                                    gridPoint.y * self.gridRowHeight + self.startYPosition);
        [bubblePatterns addObject:[NSValue valueWithCGPoint:point]];
    }
    return bubblePatterns;
}

- (NSInteger)currentNumberOfPatterns {
    return currentPoints.count + queuePoints.count;
}

- (NSArray<NSValue *> *)currentBubblePatternsWithSortAscendingXY:(BOOL)sortAscendingXY {
    NSArray<NSValue *> *currentBubblePatterns = [NSArray array];
    currentBubblePatterns = [currentBubblePatterns arrayByAddingObjectsFromArray:currentPoints];
    currentBubblePatterns = [currentBubblePatterns arrayByAddingObjectsFromArray:queuePoints];
    
    if (sortAscendingXY) {
        currentBubblePatterns = [currentBubblePatterns sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
            CGPoint point1 = obj1.CGPointValue;
            CGPoint point2 = obj2.CGPointValue;
            if (point1.y < point2.y) {
                return NSOrderedAscending;
            }
            
            if (point1.y > point2.y) {
                return NSOrderedDescending;
            }
            
            if (point1.x < point2.x) {
                return NSOrderedAscending;
            }
            
            return NSOrderedDescending;
        }];
    }
    
    return currentBubblePatterns;
}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random() % (max - min);
}

- (CGFloat)gridColumnWidth {
    return [UIScreen mainScreen].bounds.size.width / MAX_GRID_COLUMN;
}

- (CGFloat)gridRowHeight {
    return [UIScreen mainScreen].bounds.size.height / MAX_GRID_ROW;
}

- (NSInteger)currentNumberOfBubbleViews {
    return self.bubbleViews.count;
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.currentNumberOfBubbleViews) {
        return self.bubbleViews[index];
    } else {
        return nil;
    }
}

- (void)moveItemAtIndexToLastPosition:(NSInteger)index {
    BubbleView *bubbleView = self.bubbleViews[index];
    [self.bubbleViews removeObjectAtIndex:index];
    [self.bubbleViews addObject:bubbleView];
}
@end
