//
//  BubbleView.m
//  mycle
//
//  Created by Hien Pham on 2/5/18.
//  Copyright © 2018 Hien Pham. All rights reserved.
//

#import "ListBubbleView.h"
#import "BubbleView.h"
#import "PureLayout.h"
#import "ListStaticBubbleView.h"
#import "ListDynamicBubbleView.h"

static const NSString *NOTIFICATION_APP_WILL_BECOME_ACTIVE = @"NOTIFICATION_APP_WILL_BECOME_ACTIVE";
static const NSString *NOTIFICATION_APP_DID_ENTER_BACKGROUND = @"NOTIFICATION_APP_DID_ENTER_BACKGROUND";

typedef enum : NSUInteger {
    APPEAR,
    PENDDING,
    DISAPPEAR,
} LISTBUBBLEVIEWSTATE;


@interface ListBubbleView()<BubbleViewDelegate>
@property (strong, nonatomic) IBOutlet ListStaticBubbleView *listStaticBubbleView;
@property (strong, nonatomic) IBOutlet ListDynamicBubbleView *listDynamicBubbleView;
@property (strong, nonatomic) NSMutableDictionary<NSString *, UINib *> *reusableNibs;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (assign, nonatomic) LISTBUBBLEVIEWSTATE state;
@end

@implementation ListBubbleView {
}

- (void)setUpListBubbleView {
    NSString *className = NSStringFromClass([self class]);
    UIView *container = [[[NSBundle bundleForClass:self.classForCoder] loadNibNamed:className owner:self options:0] firstObject];
    [self addSubview:container];
    [container autoPinEdgesToSuperviewEdges];
    self.reusableNibs = [NSMutableDictionary dictionary];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];

}

- (void)registerNib:(UINib *)nib forBubbleViewWithReuseIdentifier:(NSString *)identifier {
    [self.reusableNibs setObject:nib forKey:identifier];
}

- (__kindof BubbleView *)dequeueReusableBubbleViewWithIdentifier:(NSString *)identifier {
    UINib *nib = self.reusableNibs[identifier];
    NSAssert(nib != nil, @"No reusable nib with identifer: %@", identifier);
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    NSAssert(objects.count > 0, @"Nib with the following identifier contain no object: %@", identifier);
    NSAssert([objects.firstObject isKindOfClass:[BubbleView class]], @"Nib with the following identifier is not kind of class BubbleView: %@", identifier);
    BubbleView *bubbleView = objects.firstObject;
    return bubbleView;
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

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (self.needCacheAnimation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.state = APPEAR;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listBubbleViewResumeAnimation) name:NOTIFICATION_APP_WILL_BECOME_ACTIVE object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listBubbleViewPauseAnimation) name:NOTIFICATION_APP_DID_ENTER_BACKGROUND object:nil];
        });
        if (newWindow) {
            if (self.state == DISAPPEAR) {
                self.state = APPEAR;
                // view will appear
                [self listBubbleViewResumeAnimation];
            }
            if (self.state == PENDDING) {
                self.state = DISAPPEAR;
            }
        } else {
            if (self.state == APPEAR) {
                self.state = PENDDING;
            }
            if (self.state == DISAPPEAR) {
                // view will disappear
                [self listBubbleViewPauseAnimation];
            }
        }
    }
    [super willMoveToWindow:newWindow];
}

- (void)setIsStatic:(BOOL)isStatic {
    _isStatic = isStatic;
    [self refreshDisplayListType];
}

- (void)refreshDisplayListType {
    if (self.isStatic) {
        if (self.listDynamicBubbleView.superview != nil) {
            [self.listDynamicBubbleView removeAllBubbleViews];
            [self.listDynamicBubbleView removeFromSuperview];
        }
        
        if (self.listStaticBubbleView.superview == nil) {
            [self.container addSubview:self.listStaticBubbleView];
            [self.listStaticBubbleView autoPinEdgesToSuperviewEdges];
            [self.listStaticBubbleView reloadData];
        }
    } else {
        if (self.listStaticBubbleView.superview != nil) {
            [self.listStaticBubbleView removeAllBubbleViews];
            [self.listStaticBubbleView removeFromSuperview];
        }
        
        if (self.listDynamicBubbleView.superview == nil) {
            [self.container addSubview:self.listDynamicBubbleView];
            [self.listDynamicBubbleView autoPinEdgesToSuperviewEdges];
            [self.listDynamicBubbleView reloadData];
        }

    }
}

- (void)reloadData {
    [self layoutIfNeeded];
    if (self.isStatic) {
        [self.listStaticBubbleView reloadData];
    } else {
        [self.listDynamicBubbleView reloadData];
    }
}

- (void)listBubbleViewPauseAnimation {
    [self.listDynamicBubbleView pauseAnimation];
}

- (void)listBubbleViewResumeAnimation {
    [self.listDynamicBubbleView resumeAnimation];
}

- (UIScrollView *)scrollView {
    if (self.isStatic) {
        return self.listStaticBubbleView;
    } else {
        return self.listDynamicBubbleView;
    }
}

- (void)insertBubblesWithCount:(NSInteger)count {
    if (self.isStatic) {
        NSLog(@"ListStaticBubbleView not support insert bubbles.");
    } else {
        [self.listDynamicBubbleView insertBubblesWithCount:count];
    }
}

- (NSInteger)numberOfBubbles {
    if ([self.dataSource respondsToSelector:@selector(numberOfBubblesInListBubbleView:)]) {
        NSInteger numberOfBubbles = [self.dataSource numberOfBubblesInListBubbleView:self];
        return numberOfBubbles;
    } else {
        return 0;
    }
}

- (BubbleView *)bubbleViewForItemAtIndex:(NSInteger)index {
    if (self.isStatic) {
        return [self.listStaticBubbleView bubbleViewForItemAtIndex:index];
    } else {
        return [self.listDynamicBubbleView bubbleViewForItemAtIndex:index];
    }
}

- (void)deleteItemAtIndex:(NSInteger)deletedIndex {
    if (self.isStatic) {
    } else {
        [self.listDynamicBubbleView deleteItemAtIndex:deletedIndex];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    for (int i = 0; i < self.numberOfBubbles; i++) {
        BubbleView *bubbleView = [self bubbleViewForItemAtIndex:i];
        CGPoint touchPoint = [recognizer locationInView:self.scrollView];
        CGPoint bubblePoint = [self.scrollView convertPoint:touchPoint toView:bubbleView];
        if ([bubbleView.touchView.layer.presentationLayer hitTest:bubblePoint]) {
            __block UITapGestureRecognizer *blockRec = recognizer;
            __weak typeof(self) weakSelf = self;
            [bubbleView handleTap:recognizer completion:^(BOOL canTap) {
                // Disbale tap event in 2.0 second
                if (!weakSelf.multiSelection && canTap) {
                    [blockRec setEnabled:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                                   dispatch_get_main_queue(), ^
                                   {
                                       [blockRec setEnabled:YES];
                                   });
                }
            }];
            break;
        }
    }
}



@end
