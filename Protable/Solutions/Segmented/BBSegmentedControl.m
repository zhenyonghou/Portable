//
//  BBSegmentedControl.m
//
//  Created by mumuhou on 15/7/14.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "BBSegmentedControl.h"

@interface HGScrollView : UIScrollView

@end

@implementation HGScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@interface BBSegmentedControl()

@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray *segmentWidthsArray;
@property (nonatomic, strong) HGScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *registerScrollView;

@end

@implementation BBSegmentedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _backgroundColor = [UIColor whiteColor];
    
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.bottomLineView];
    
    self.scrollView = [[HGScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.selectionIndicatorStripLayer = [CALayer layer];

    self.bottomLineHeight = 0.5f;
    self.bottomLineColor = [UIColor lightGrayColor];
    
    self.selectionIndicatorHeight = 2.f;
    self.selectionIndicatorColor = [UIColor blackColor];
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)dealloc {
    if (self.registerScrollView) {
        [self.registerScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    self.bottomLineView.backgroundColor = bottomLineColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
}

- (void)updateSegmentsRects
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
        self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
    
    self.bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - self.bottomLineHeight, CGRectGetWidth(self.frame), self.bottomLineHeight);
}

- (NSUInteger)sectionCount
{
    return self.sectionTitles.count;
}

- (CGFloat)totalSegmentedControlWidth
{
    return self.sectionTitles.count * self.segmentWidth;
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
    _sectionTitles = sectionTitles;
    
    [self setNeedsLayout];
}

- (void)registerObserverForScrollView:(UIScrollView *)scrollView
{
    self.registerScrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor
{
    _selectionIndicatorColor = selectionIndicatorColor;
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
}

#pragma mark- Drawing

- (CGSize)measureTitleAtIndex:(NSUInteger)index
{
    NSString *title = self.sectionTitles[index];
    BOOL selected = (index == self.selectedSegmentIndex);
    
    NSDictionary *titleAttrs = selected ? self.selectedTitleTextAttributes : self.titleTextAttributes;
    CGSize size = [title sizeWithAttributes:titleAttrs];
    return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index
{
    NSString *title = self.sectionTitles[index];
    BOOL selected = (index == self.selectedSegmentIndex);
    
    NSDictionary *titleAttrs = selected ? self.selectedTitleTextAttributes : self.titleTextAttributes;
    
    return [[NSAttributedString alloc] initWithString:title attributes:titleAttrs];
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);

    self.scrollView.layer.sublayers = nil;

    [self.sectionTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGSize titleSize = [self measureTitleAtIndex:idx];

        CGFloat y = roundf(CGRectGetHeight(self.frame) - titleSize.height) / 2;

        CGRect titleRect = CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - titleSize.width) / 2, y, titleSize.width, titleSize.height);
        titleRect = CGRectMake(ceilf(titleRect.origin.x), ceilf(titleRect.origin.y), ceilf(titleRect.size.width), ceilf(titleRect.size.height));

        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.frame = titleRect;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.truncationMode = kCATruncationEnd;
        titleLayer.string = [self attributedTitleAtIndex:idx];
        titleLayer.contentsScale = [[UIScreen mainScreen] scale];

        [self.scrollView.layer addSublayer:titleLayer];
    }];

    if (!self.selectionIndicatorStripLayer.superlayer) {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
    }
}

- (CGRect)frameForSelectionIndicator
{
    CGFloat indicatorYOffset = self.bounds.size.height - self.selectionIndicatorHeight;

    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                      indicatorYOffset,
                      self.segmentWidth,
                      self.selectionIndicatorHeight);
}

#pragma mark- Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        
        if (segment != self.selectedSegmentIndex && segment < self.sectionTitles.count) {
            // Check if we have to do anything with the touch event
            [self setSelectedSegmentIndex:segment animated:YES notify:YES];
        }
    }
}

#pragma mark- Scrolling

- (void)scrollToSelectedSegmentIndex:(BOOL)animated {
    CGRect rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                             0,
                                             self.segmentWidth,
                                             self.frame.size.height);
    
    CGFloat selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);

    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Index Change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    _selectedSegmentIndex = index;
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];

    [self scrollToSelectedSegmentIndex:animated];

    if (animated) {
        if (notify) {
            [self notifyForSegmentChangeToIndex:index];
        }

        self.selectionIndicatorStripLayer.actions = nil;
        
        // Animate to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];

        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
    } else {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        if (notify) {
            [self notifyForSegmentChangeToIndex:index];
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
#ifdef BBSegmentedControlScrollStyle
    if ([object isEqual:self.registerScrollView] && [keyPath isEqualToString:@"contentOffset"]) {
        CGFloat indicatorOffsetX = (self.registerScrollView.contentOffset.x / self.registerScrollView.contentSize.width) * [self totalSegmentedControlWidth];
        CGFloat indicatorOffsetY = self.bounds.size.height - self.selectionIndicatorHeight;
        self.selectionIndicatorStripLayer.frame = CGRectMake(indicatorOffsetX, indicatorOffsetY, self.segmentWidth, self.selectionIndicatorHeight);
    }
#endif
    
}

@end
