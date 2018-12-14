//
//  ListDynamicBubbleView.m
//  mycle
//
//  Created by Hien Pham on 3/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ListDynamicBubbleView.h"
#import "BubbleView.h"
#import "PureLayout.h"
#import "ChildListDynamicBubbleViewManager.h"

@interface ListDynamicBubbleView()<BubbleViewDelegate, ChildListBubbleViewManagerDataSource, ChildListBubbleViewManagerDelegate, ChildListDynamicBubbleViewManagerDelegate, UIScrollViewDelegate>
@property (strong, atomic) NSArray<ChildListDynamicBubbleViewManager *> *managers;
@end

@implementation ListDynamicBubbleView

- (void)setUpListBubbleView {
    self.alwaysBounceVertical = YES;
    self.delegate = self;
    self.managers = [NSArray array];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpListBubbleView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpListBubbleView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpListBubbleView];
}

-(void)removeAllBubbleViews {
    for (ChildListBubbleViewManager *manager in self.managers) {
        [manager removeAllBubbleViews];
    }
    self.managers = [NSArray array];
}

- (void)reloadData {
    [self removeAllBubbleViews];
    [self insertBubblesWithCount:self.parent.numberOfBubbles];
}

- (void)pauseAnimation {
    for (ChildListDynamicBubbleViewManager *manager in self.managers) {
        [manager pauseAnimation];
    }
}

- (void)resumeAnimation {
    for (ChildListDynamicBubbleViewManager *manager in self.managers) {
        [manager resumeAnimation];
    }
}

- (ChildListDynamicBubbleViewManager *)appendNewManager {
    ChildListDynamicBubbleViewManager *previous = self.managers.count > 0? self.managers.lastObject : nil;
    ChildListDynamicBubbleViewManager *manager = [[ChildListDynamicBubbleViewManager alloc] initWithScrollView:self dataSourceAndDelegate:self];
    manager.listDynamicManagerDelegate = self;
    manager.parent = self;
    if (previous != nil) {
        manager.startYPosition = previous.startYPosition + previous.calculateContentSize.height;
    }
    self.managers = [self.managers arrayByAddingObject:manager];
    [manager reloadData];
    return manager;
}

- (BOOL)isLastManager:(ChildListDynamicBubbleViewManager *)manager {
    return (self.managers.lastObject == manager);
}

- (void)insertBubblesWithCount:(NSInteger)count {
    NSAssert(count >= 0, @"Inserted count must be larger or equal 0");
    
    NSInteger remains = count;
    
    if (self.managers.count > 0) {
        ChildListDynamicBubbleViewManager *lastManager = self.managers.lastObject;
        NSInteger numberOfAvailableSlots = DYNAMIC_MAX_NUMBER_OF_BUBBLES - lastManager.currentNumberOfBubbleViews;
        if (numberOfAvailableSlots > 0) {
            [lastManager insertBubblesWithCount:numberOfAvailableSlots];
            remains -= numberOfAvailableSlots;
        }
    }
    
    NSInteger numberOfEventPage = remains / DYNAMIC_MAX_NUMBER_OF_BUBBLES;
    for (int index = 0; index < numberOfEventPage; index++) {
        ChildListBubbleViewManager *manager = [self appendNewManager];
        remains -= manager.numberOfBubbles;
    }
    
    CGFloat numberOfItemsInFinalOddPage = remains;
    if (numberOfItemsInFinalOddPage > 0) {
        ChildListBubbleViewManager *manager = [self appendNewManager];
        remains -= manager.numberOfBubbles;
    }
        
    [self updateContentSize];
}

- (void)updateContentSize {
    CGFloat height = 0;
    for (ChildListBubbleViewManager *manager in self.managers) {
        height += manager.calculateContentSize.height;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize contentSize = CGSizeMake(width, height);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.contentSize = contentSize;
    }];
}

- (NSInteger)numberOfBubblesInChildList:(ChildListBubbleViewManager *)childListBubbleViewManager {
    NSInteger numberOfBubblesInChildList;
    if ([childListBubbleViewManager isKindOfClass:[ChildListDynamicBubbleViewManager class]]) {
        ChildListDynamicBubbleViewManager *childListDynamicBubbleViewManager = (ChildListDynamicBubbleViewManager *)childListBubbleViewManager;
        NSInteger index = [self.managers indexOfObject:childListDynamicBubbleViewManager];
        if (index != NSNotFound) {
            NSInteger numberOfTotalPage = ceilf((CGFloat)self.parent.numberOfBubbles / (CGFloat)DYNAMIC_MAX_NUMBER_OF_BUBBLES);
            if (index < numberOfTotalPage) {
                NSInteger numberOfEventPage = self.parent.numberOfBubbles / DYNAMIC_MAX_NUMBER_OF_BUBBLES;
                if (index < numberOfEventPage) {
                    numberOfBubblesInChildList = DYNAMIC_MAX_NUMBER_OF_BUBBLES;
                } else {
                    CGFloat numberOfItemsInFinalOddPage = self.parent.numberOfBubbles % DYNAMIC_MAX_NUMBER_OF_BUBBLES;
                    numberOfBubblesInChildList = numberOfItemsInFinalOddPage;
                }
            } else {
                numberOfBubblesInChildList = 0;
            }
        } else {
            numberOfBubblesInChildList = 0;
        }
    } else {
        NSLog(@"Invalid child list manager. Must be of class: %@, Current is: %@", NSStringFromClass([ChildListDynamicBubbleViewManager class]), NSStringFromClass([childListBubbleViewManager class]));
        numberOfBubblesInChildList = 0;
    }
    return numberOfBubblesInChildList;
}

- (BubbleView *)childListBubbleViewManager:(ChildListBubbleViewManager *)childListBubbleViewManager bubbleViewForItemAtIndex:(NSInteger)index {
    if ([childListBubbleViewManager isKindOfClass:[ChildListDynamicBubbleViewManager class]]) {
        ChildListDynamicBubbleViewManager *childListDynamicBubbleViewManager = (ChildListDynamicBubbleViewManager *)childListBubbleViewManager;
        NSInteger managerIndex = [self.managers indexOfObject:childListDynamicBubbleViewManager];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:managerIndex];
        NSInteger realIndex = [self convertToRealIndexFromIndexPath:indexPath];
        BubbleView *bubbleView = [self.parent.dataSource listBubbleView:self.parent bubbleViewForItemAtIndex:realIndex];
        return bubbleView;
    } else {
        @throw [NSString stringWithFormat:@"Invalid child list manager. Must be of class: %@, Current is: %@", NSStringFromClass([ChildListDynamicBubbleViewManager class]), NSStringFromClass([childListBubbleViewManager class])];
    }
}

/**
 *  indexPath.section => managerIndex
 *  indexPath.item => managerIndex
 */
- (NSInteger)convertToRealIndexFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger managerIndex = indexPath.section;
    NSInteger itemIndex = indexPath.item;
    NSInteger realIndex = 0;
    for (int index = 0; index < managerIndex; index++) {
        ChildListBubbleViewManager *manager = self.managers[index];
        realIndex += manager.numberOfBubbles;
    }
    
    realIndex += itemIndex;
    
    return realIndex;
}

/**
 *  The same as convertToRealIndexFromIndexPath's explanation
 */
- (NSIndexPath *)indexPathFromRealIndex:(NSInteger)realIndex {
    NSInteger remains = realIndex + 1;
    NSInteger managerIndex = 0;
    ChildListDynamicBubbleViewManager *manager = self.managers.firstObject;
    while (remains > manager.numberOfBubbles) {
        remains -= manager.numberOfBubbles;
        managerIndex ++;
        manager = self.managers[managerIndex];
    }
    
    NSInteger itemIndex = remains - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:managerIndex];
    return indexPath;
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self indexPathFromRealIndex:index];
    
    NSInteger managerIndex = indexPath.section;
    if (managerIndex < 0 || managerIndex >= self.managers.count) {
        return nil;
    }
    ChildListDynamicBubbleViewManager *manager = self.managers[managerIndex];
    
    NSInteger itemIndex = indexPath.item;
    if (itemIndex < 0 || itemIndex >= manager.numberOfBubbles) {
        return nil;
    }
    BubbleView *bubbleView = [manager bubbleViewForItemAtIndex:itemIndex];
    
    return bubbleView;
}

- (void)childListBubbleViewManager:(ChildListBubbleViewManager *)childListBubbleViewManager didSelectAtIndex:(NSInteger)index {
    if ([self.parent.delegate respondsToSelector:@selector(listBubbleView:didSelectAtIndex:)]) {
        NSInteger managerIndex = [self.managers indexOfObject:(ChildListDynamicBubbleViewManager *)childListBubbleViewManager];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:managerIndex];
        NSInteger realIndex = [self convertToRealIndexFromIndexPath:indexPath];
        [self.parent.delegate listBubbleView:self.parent didSelectAtIndex:realIndex];
    }
}

- (NSInteger)currentNumberOfBubbleViews {
    NSInteger currentNumberOfBubbleViews = 0;
    for (ChildListDynamicBubbleViewManager *manager in self.managers) {
        currentNumberOfBubbleViews += manager.currentNumberOfBubbleViews;
    }
    return currentNumberOfBubbleViews;
}

- (void)childListDynamicBubbleViewManager:(ChildListDynamicBubbleViewManager *)childListDynamicBubbleViewManager didRemoveBubbleViewAtIndex:(NSInteger)index {
    // Remove empty managers
    NSMutableArray<ChildListDynamicBubbleViewManager *> *managers = [NSMutableArray arrayWithArray:self.managers];
    ChildListDynamicBubbleViewManager *lastManager = managers.lastObject;
    while (lastManager != nil && lastManager.numberOfBubbles <= 0) {
        [managers removeObject:lastManager];
        lastManager = managers.lastObject;
    }
    self.managers = managers;
    
    [self updateContentSize];
}

- (void)childListDynamicBubbleViewManagerDidCloseBubbleView:(ChildListDynamicBubbleViewManager *)childListDynamicBubbleViewManager {
    [self updateContentSize];
}

- (void)deleteItemAtIndex:(NSInteger)deletedIndex {
    NSIndexPath *indexPath = [self indexPathFromRealIndex:deletedIndex];
    NSInteger managerIndex = indexPath.section;
    ChildListDynamicBubbleViewManager *manager = self.managers[managerIndex];
    NSInteger itemIndex = indexPath.item;
    [manager moveItemAtIndexToLastPosition:itemIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
@end
