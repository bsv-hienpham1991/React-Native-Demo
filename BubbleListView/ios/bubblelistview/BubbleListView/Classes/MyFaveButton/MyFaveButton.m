//
//  FaveButton.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "MyFaveButton.h"
#import "Ring.h"
#import "Spark.h"
#import "Easing.h"

@interface UIView(TweenAnimation)
- (void)animateSelected:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(CGFloat) duration delay:(CGFloat)delay;
@end

@implementation UIView(TweenAnimation)
- (void)animateSelected:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(CGFloat) duration delay:(CGFloat)delay {
    NSArray *tweenValues = [self generateTweenValues:0 to:1.0 duration:duration];
    
    self.backgroundColor = fillColor;
    
    CGFloat selectedDelay = isSelected ? delay : 0;
    if(isSelected){
        self.alpha  = 0;
        [UIView animateWithDuration:0 delay:selectedDelay options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = tweenValues;
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = CACurrentMediaTime() + selectedDelay;
    [self.layer addAnimation:scaleAnimation forKey:nil];
}

- (NSArray *)generateTweenValues:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration{
    NSMutableArray *values = [NSMutableArray array];
    CGFloat fps            = 60;
    CGFloat tpf            = duration / fps;
    CGFloat c              = to - from;
    CGFloat d              = duration;
    CGFloat t              = 0.0;
    
    while(t < d){
        CGFloat scale = [Easing ExtendedEaseOut:t b:from c:c d:d a:c+0.001 p:0.39988]; // p=oscillations, c=amplitude(velocity)
        [values addObject:@(scale)];
        t += tpf;
    }
    return values;
}
@end

@interface MyFaveButton(){
    CGFloat duration;
    CGFloat expandDuration;
    CGFloat collapseDuration;
    CGFloat faveIconShowDelay;
    NSArray *dotRadiusFactors;
    NSInteger sparkGroupCount;
    
    //    IBOutlet UIView *faveIcon;
}
@end

@implementation MyFaveButton
@synthesize faveIcon;

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self applyInit];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self applyInit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpDefault];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self animateSelect:self.isSelected duration:duration];
}

#pragma mark - configure
- (void)setUpDefault {
    duration            = 1.0;
    expandDuration      = 0.1298;
    collapseDuration    = 0.1089;
    faveIconShowDelay   = expandDuration + collapseDuration / 2.0;
    dotRadiusFactors    = @[@(0.0633),@(0.04)];
    sparkGroupCount     = 7;
    
    _normalColor         = RGBA(137, 156, 127, 1);
    _selectedColor       = RGBA(226, 38, 77, 1);
    _dotFirstColor       = RGBA(152, 219, 236, 1);
    _dotSecondColor      = RGBA(247, 188, 48, 1);
    _circleFromColor     = RGBA(221, 70, 136, 1);
    _circleToColor       = RGBA(205, 143, 246, 1);
}

- (void)applyInit{
    [self setImage:[UIImage new] forState:UIControlStateNormal];
    [self setImage:[UIImage new] forState:UIControlStateSelected];
    [self setTitle:nil forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateSelected];
    [self addActions];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"faveIcon"]) {
        NSLog(@"Old: %@, New: %@", change[@"old"], change[@"new"]);
        if (self.faveIcon == nil) {
            
        }
    }
}

- (void)addActions{
    [self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggle:(MyFaveButton *)sender{
    sender.selected = !sender.isSelected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(myFaveButton:didSelected:)]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate myFaveButton:sender didSelected:sender.isSelected];
        });
    }
}
#pragma mark - spark
- (NSArray<Spark *> *)createSparks:(CGFloat)radius{
    NSMutableArray *sparks = [NSMutableArray array];
    CGFloat        step    = 360.0 / sparkGroupCount;
    CGFloat        base    = self.bounds.size.width;
    NSArray        *dotRadius = @[@(base * [dotRadiusFactors.firstObject doubleValue]),@(base * [dotRadiusFactors.lastObject doubleValue])];
    CGFloat        offSet  = 10.f;
    
    for(int index = 0; index < sparkGroupCount ;index++){
        CGFloat theta = step * index + offSet;
        DotColors *colors = [self dotColors:index];
        
        Spark *spark = [Spark createSparkInView:self radius:radius firstColor:colors.firstObject secondColor:colors.lastObject angle:theta dotRadius:dotRadius];
        [sparks addObject:spark];
    }
    return sparks;
}

- (DotColors *)dotColors:(int) index{
    if(self.delegate && [self.delegate respondsToSelector:@selector(myFaveButtonDotColors:)]){
        NSArray *colors = [self.delegate myFaveButtonDotColors:self];
        int colorIndex = index < colors.count? index :index % colors.count;
        return colors[colorIndex];
    }
    return @[_dotFirstColor,_dotSecondColor];
}

- (void)setFaveIcon:(UIView *)p_faveIcon {
    faveIcon = p_faveIcon;
    if (p_faveIcon == nil) {
        NSLog(@"Set fave icon to nil");
    }
}

#pragma mark - animation
- (void)animateSelect:(BOOL)isSelected duration:(CGFloat)duration{
    UIColor *color = isSelected? _selectedColor : _normalColor;
    if ([self.delegate respondsToSelector:@selector(myFaveButton:willAnimateSelected:)]) {
        [self.delegate myFaveButton:self willAnimateSelected:isSelected];
    }
    [faveIcon animateSelected:isSelected fillColor:color duration:duration delay:faveIconShowDelay];
    
    if(isSelected){
        CGFloat radius = self.bounds.size.width * 1.3 / 2;
        CGFloat igniteFromRadius = radius * 0.8;
        CGFloat igniteToRadius   = radius * 1.1;
        
        Ring *ring = [Ring createRingInView:self radius:0.01 lineWidth:3 fillColor:_circleFromColor];
        NSArray *sparks = [self createSparks:igniteFromRadius];
        
        [ring animateToRadius:radius toColor:_circleToColor duration:expandDuration delay:0];
        [ring animateColapse:radius duration:collapseDuration delay:expandDuration];
        
        for (Spark *spark in sparks) {
            [spark animateIgniteShow:igniteToRadius duration:0.4 delay:collapseDuration / 3.0];
            [spark animateIgniteHide:0.7 delay:0.2];
        }
    }
}
@end

