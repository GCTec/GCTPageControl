//
//  GCTUIPageControl.h
//  GCTUIPageControlDemo
//
//  Created by 罗树新 on 2018/12/12.
//  Copyright © 2018 罗树新. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCTUIPageControl : UIView

/**
 页面总数
 */
@property(nonatomic, assign) NSInteger numberOfPages;

/**
 当前展示的页
 */
@property(nonatomic, assign) NSInteger currentPage;

/**
 单张隐藏
 */
@property(nonatomic, assign) BOOL hidesForSinglePage;

/**
 当前页显示延时
 */
@property(nonatomic, assign) BOOL defersCurrentPageDisplay;

/**
 更新当前页
 */
- (void)updateCurrentPageDisplay;

/**
 获取最小size
 
 @param pageCount pageCount
 @return 能够显示下的最小size
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

/**
 正常状态的试图（非当前页）
 
 @def (4, 4) roundView
 */
@property(nonatomic, strong) UIView * normalPageIndicatorView;

/**
 选中状态的试图（当前页）
 
 @def (4, 4) roundView
 */
@property(nonatomic, strong) UIView * currentPageIndicatorView;

/**
 分页控件的试图之间的间距
 
 @def 8
 */
@property(nonatomic, assign) CGFloat padding;

@end

@interface GCTUIAnimatedPageControl: GCTUIPageControl
- (void)followScrollViewDidScroll:(UIScrollView *)scrollView;
@property (nonatomic, assign) BOOL circleAnimation;
@end


@interface GCTUIJerkyPageControl : GCTUIAnimatedPageControl

@end

NS_ASSUME_NONNULL_END
