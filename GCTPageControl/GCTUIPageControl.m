//
//  GCTUIPageControl.m
//  GCTUIPageControlDemo
//
//  Created by 罗树新 on 2018/12/12.
//  Copyright © 2018 罗树新. All rights reserved.
//

#import "GCTUIPageControl.h"

@interface GCTUIPageControl ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *normalViews;
@property (nonatomic, strong) UIView *currentNormalPageIndicatorView;
@property (nonatomic, assign) CGFloat currentPageIndicatorWidth;
@property (nonatomic, assign) CGFloat normalPageIndicatorWidth;
@end

@implementation GCTUIPageControl
@synthesize currentPageIndicatorView = _currentPageIndicatorView;

#pragma mark - System
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commentInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commentInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat allWidth = [self sizeForNumberOfPages:self.numberOfPages].width;
    self.backView.frame = CGRectMake(0, 0, allWidth, CGRectGetHeight(self.bounds));
    for (UIView *view in self.normalViews) {
        view.center = CGPointMake(view.center.x, self.bounds.size.height/2.f);
    }
    self.backView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    self.currentPageIndicatorView.center = CGPointMake(self.currentNormalPageIndicatorView.center.x, self.bounds.size.height/2.f);
}

#pragma mark - Private
- (void)commentInit {
    self.normalPageIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    self.normalPageIndicatorView.layer.masksToBounds = YES;
    self.normalPageIndicatorView.layer.cornerRadius = 2;
    self.normalPageIndicatorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.normalPageIndicatorWidth = 4;
    self.currentPageIndicatorWidth = 4;

    self.padding = 8;
    [self addSubview:self.backView];
}

- (UIView*)duplicate:(UIView*)view {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
        return (UIView *)[NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
#pragma clang diagnostic pop
}


#pragma mark - Public

- (void)updateCurrentPageDisplay {
    if (self.defersCurrentPageDisplay) {
        // 获取的视图
        self.currentNormalPageIndicatorView.hidden = NO;
        self.currentNormalPageIndicatorView = self.normalViews[self.currentPage];
        _currentPageIndicatorView.center = self.currentNormalPageIndicatorView.center;
    }
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    CGFloat allWidth = _numberOfPages * CGRectGetWidth(self.normalPageIndicatorView.bounds) + (_numberOfPages - 1) * self.padding;
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat normalHeight = CGRectGetHeight(self.normalPageIndicatorView.bounds) + 2;
    CGFloat currentHeight = CGRectGetHeight(self.currentPageIndicatorView.bounds) + 2;
    height = MAX(normalHeight, currentHeight);
    width = MIN(allWidth, CGRectGetWidth([UIScreen mainScreen].bounds));
    return CGSizeMake(width, height);
}
#pragma mark - Setter/Getter

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage > self.numberOfPages) {
        return;
    }
    _currentPage = currentPage;
    if (self.defersCurrentPageDisplay) {
        return;
    }
    if (currentPage < self.normalViews.count && self.normalViews.count > 0) {
        self.currentNormalPageIndicatorView = self.normalViews[currentPage];
        _currentPageIndicatorView.center = self.currentNormalPageIndicatorView.center;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self.normalViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.normalViews removeAllObjects];
    [_currentPageIndicatorView removeFromSuperview];
    // 一组视图的宽度
    CGFloat allWidth = [self sizeForNumberOfPages:numberOfPages].width;
    self.backView.frame = CGRectMake((self.bounds.size.width - allWidth) /2.f, 0, allWidth, CGRectGetHeight(self.bounds));
    
    // 创建正常状态的视图
    for (int i = 0; i < self.numberOfPages; i ++) {
        CGFloat pageViewX =  i *self.padding + i *_normalPageIndicatorView.bounds.size.width;
        
        UIView * pageView = [self duplicate:_normalPageIndicatorView];
        pageView.frame = CGRectMake(pageViewX, 0, _normalPageIndicatorView.bounds.size.width, _normalPageIndicatorView.bounds.size.height);
        pageView.center = CGPointMake(pageView.center.x, self.bounds.size.height/2.f);
        
        pageView.layer.masksToBounds = _normalPageIndicatorView.layer.masksToBounds;
        pageView.layer.cornerRadius = _normalPageIndicatorView.layer.cornerRadius;
        
        [self.backView addSubview:pageView];
        [self.normalViews addObject:pageView];
        if (i == 0) {
            // 设置frame
            self.currentNormalPageIndicatorView = pageView;
            [self.backView addSubview:_currentPageIndicatorView];
            _currentPageIndicatorView.center = self.currentNormalPageIndicatorView.center;
        }
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (NSMutableArray *)normalViews {
    if (!_normalViews) {
        _normalViews = [[NSMutableArray alloc] init];
    }
    return _normalViews;
}

- (UIView *)currentPageIndicatorView {
    if (!_currentPageIndicatorView) {
        _currentPageIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _currentPageIndicatorView.layer.masksToBounds = YES;
        _currentPageIndicatorView.layer.cornerRadius = 2;
        _currentPageIndicatorView.backgroundColor = [UIColor whiteColor];
    }
    return _currentPageIndicatorView;
}

- (void)setCurrentPageIndicatorView:(UIView *)currentPageIndicatorView {
    if (_currentPageIndicatorView) {
        [_currentPageIndicatorView removeFromSuperview];
    }
    _currentPageIndicatorView = currentPageIndicatorView;
    _currentPageIndicatorWidth = CGRectGetWidth(_currentPageIndicatorView.bounds);
    [self addSubview:_currentPageIndicatorView];
}

- (void)setNormalPageIndicatorView:(UIView *)normalPageIndicatorView {
    _normalPageIndicatorView = normalPageIndicatorView;
    self.normalPageIndicatorWidth = CGRectGetWidth(normalPageIndicatorView.bounds);
    self.numberOfPages = self.numberOfPages;
}

@end

@implementation GCTUIAnimatedPageControl

- (void)followScrollViewDidScroll:(UIScrollView *)scrollView {
    // 点击和动画的时候不需要设置
    NSInteger count = self.normalViews.count;;
    
    if (count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger index = offsetX / CGRectGetWidth(scrollView.bounds);
    
    if (!self.circleAnimation && (index >= self.numberOfPages - 1 || offsetX < 0)) {
        return;
    }
    
    NSInteger currentIndex = index % count;
    
    NSInteger nextIndex = 0;
    if (currentIndex < count - 1) {
        nextIndex = currentIndex + 1;
    } else if (currentIndex == count -1) {
        nextIndex = 0;
    }
    
    if (self.normalViews) {
        // 左边按钮
        UIView *currentItem = self.normalViews[currentIndex];
        UIView *nextItem = self.normalViews[nextIndex];
        CGFloat offsetW = currentItem.center.x - nextItem.center.x;
        CGFloat percent = [self percentForScrollOffset:offsetX ofScrollView:scrollView];
        CGFloat centerY = self.currentPageIndicatorView.center.y;
        self.currentPageIndicatorView.center = CGPointMake(nextItem.center.x +offsetW * (1 - percent) , centerY);
    }
}

- (CGFloat)percentForScrollOffset:(CGFloat)offset ofScrollView:(UIScrollView *)scrollView {
    CGFloat percent = offset/CGRectGetWidth(scrollView.bounds) - (NSInteger)(offset/CGRectGetWidth(scrollView.bounds));
    
    if (percent > 1) percent = 1;
    if (percent < -1) percent = -1;
    return percent;
}
@end


@implementation GCTUIJerkyPageControl

- (void)followScrollViewDidScroll:(UIScrollView *)scrollView {
    // 点击和动画的时候不需要设置
    NSInteger count = self.normalViews.count;;
    
    if (count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger index = offsetX / CGRectGetWidth(scrollView.bounds);
    
    if (!self.circleAnimation && (index >= self.numberOfPages - 1 || offsetX < 0)) {
        return;
    }
    NSInteger currentIndex = index % count;
    
    NSInteger nextIndex;
    if (currentIndex < count - 1) {
        nextIndex = currentIndex + 1;
        if (self.normalViews) {
            // 左边按钮
            UIView *currentItem = self.normalViews[currentIndex];
            UIView *nextItem = self.normalViews[nextIndex];
            [self setUpJerkyIndicatorOffset:offsetX nextItem:nextItem currentItem:currentItem scrollView:scrollView];
        }
    } else if (currentIndex == count -1) {
        nextIndex = 0;
        if (self.normalViews) {
            // 左边按钮
            UIView *currentItem = self.normalViews[currentIndex];
            UIView *nextItem = self.normalViews[nextIndex];
            
            CGFloat offsetW = currentItem.center.x - nextItem.center.x;
            CGFloat percent = [self percentForScrollOffset:offsetX ofScrollView:scrollView];
            CGFloat centerY = self.currentPageIndicatorView.center.y;
            self.currentPageIndicatorView.center = CGPointMake(nextItem.center.x +offsetW * (1 - percent) , centerY);
        }
    }
}

// 设置下标偏移（毛毛虫效果）
- (void)setUpJerkyIndicatorOffset:(CGFloat)offsetX nextItem:(UIView *)nextItem currentItem:(UIView *)currentItem scrollView:(UIScrollView *)scrollView {
    
    if (!currentItem || !nextItem) return;
    
    CGFloat startIndicatorW = self.currentPageIndicatorWidth;
    
    // Start for x
    CGFloat startX = 0;
    if (offsetX < 0) {
        startX = currentItem.center.x - currentItem.frame.origin.x -startIndicatorW /2.f;
        offsetX = CGRectGetWidth(scrollView.bounds) + offsetX;
    }else{
        startX = currentItem.center.x - startIndicatorW /2.f;
    }
    
    CGFloat percent = [self percentForScrollOffset:offsetX ofScrollView:scrollView];
    CGFloat averageSpace = self.padding + (CGRectGetWidth(currentItem.frame) + CGRectGetWidth(nextItem.frame)) / 2;;
    CGFloat a = [self curveFuncA:percent] * averageSpace ;// 左侧随着变短的部分
    CGFloat b = [self curveFuncB:percent] * averageSpace ;// 右侧随着变长的部分
    CGFloat x = startX  + a;
    CGFloat w = startIndicatorW - a + b;
    self.currentPageIndicatorView.frame = CGRectMake(x, self.currentPageIndicatorView.frame.origin.y, w, self.currentPageIndicatorView.frame.size.height);
}

- (CGFloat)percentForScrollOffset:(CGFloat)offset ofScrollView:(UIScrollView *)scrollView {
    CGFloat percent = offset/CGRectGetWidth(scrollView.bounds) - (NSInteger)(offset/CGRectGetWidth(scrollView.bounds));
    
    if (percent > 1) percent = 1;
    if (percent < -1) percent = -1;
    return percent;
}

-(CGFloat)curveFuncA:(CGFloat)x{
    return 1.0 - cos(asin(x));
}

-(CGFloat)curveFuncB:(CGFloat)x{
    return sin(acos(1-x));
}

@end
