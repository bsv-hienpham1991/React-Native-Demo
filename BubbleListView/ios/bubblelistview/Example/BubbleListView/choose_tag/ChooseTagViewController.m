//
//  RegisterMycleChooseTagViewController.m
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ChooseTagViewController.h"
#import "ListBubbleView.h"
#import "TagBubbleView.h"
#import "SVPullToRefresh.h"
#import "PureLayout.h"

#define TagBubbleViewReuseId @"TagBubbleView"

@interface ChooseTagViewController ()<ListBubbleViewDataSource, ListBubbleViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet ListBubbleView *listBubbleView;
@property (nonatomic, assign) ChooseTagType viewType;
@property (strong, atomic) NSMutableArray<NSNumber *> *listBubbleIndexes;
@end

@implementation ChooseTagViewController

- (instancetype)initWithChooseTagType:(ChooseTagType)type {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.viewType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.contentView.hidden = YES;
    self.listBubbleIndexes = [NSMutableArray array];
    NSInteger numberOfInsertedValues = 12;
    for (int i = 0; i < numberOfInsertedValues; i++) {
        [self.listBubbleIndexes addObject:@(i)];
    }
    self.listBubbleView.isStatic = (self.viewType == ChooseTagTypeStatic);
    self.listBubbleView.multiSelection = YES;
    self.listBubbleView.needCacheAnimation = YES;
    [self.listBubbleView registerNib:[UINib nibWithNibName:TagBubbleViewReuseId bundle:nil] forBubbleViewWithReuseIdentifier:TagBubbleViewReuseId];
    self.listBubbleView.dataSource = self;
    self.listBubbleView.delegate = self;
    
    [self addLoadMoreToListBubbleViewIfNeeded];
    [self.listBubbleView reloadData];
}


#pragma mark - Display

- (void)addLoadMoreToListBubbleViewIfNeeded {
    if (!self.listBubbleView.isStatic) {
        [self.listBubbleView.scrollView addInfiniteScrollingWithActionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger numberOfInsertedValues = 10;
                for (int i = 0; i < numberOfInsertedValues; i++) {
                    [self.listBubbleIndexes addObject:@(self.listBubbleIndexes.lastObject.integerValue + 1)];
                }
                [self.listBubbleView insertBubblesWithCount:numberOfInsertedValues];
                [self.listBubbleView.scrollView.infiniteScrollingView stopAnimating];
                
                if (self.listBubbleIndexes.count >= 40) {
                    self.listBubbleView.scrollView.showsInfiniteScrolling = NO;
                }
            });
        }];
    }
    self.listBubbleView.scrollView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

#pragma mark - ListBubbleView Delegate + Datasource

- (NSInteger)numberOfBubblesInListBubbleView:(ListBubbleView *)listBubbleView {
    return self.listBubbleIndexes.count;
}

- (BubbleView *)listBubbleView:(ListBubbleView *)listBubbleView bubbleViewForItemAtIndex:(NSInteger)index {
    TagBubbleView *bubbleView = [listBubbleView dequeueReusableBubbleViewWithIdentifier:TagBubbleViewReuseId];
    bubbleView.tagNameLabel.text = self.listBubbleIndexes[index].stringValue;
    return bubbleView;
}

- (void)listBubbleView:(ListBubbleView *)listBubbleView didSelectAtIndex:(NSInteger)index {
    NSLog(@"didSelectAtIndex: %ld. Item title: %ld. List indexes: %@", index, self.listBubbleIndexes[index].integerValue, self.listBubbleIndexes);
    if (self.viewType == ChooseTagTypeDelete) {
        [listBubbleView deleteItemAtIndex:index];
        [self.listBubbleIndexes removeObjectAtIndex:index];
    } else {
        UIViewController *vc = [UIViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
