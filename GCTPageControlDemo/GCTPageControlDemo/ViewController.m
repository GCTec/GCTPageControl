//
//  ViewController.m
//  GCTPageControlDemo
//
//  Created by 罗树新 on 2018/12/12.
//  Copyright © 2018 罗树新. All rights reserved.
//

#import "ViewController.h"
#import "DemoCollectionViewCell.h"
#import "GCTUIPageControl.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <NSString *> *items;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) GCTUIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger numberPages;
@property (nonatomic, assign) BOOL circle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberPages = 5;
    
    [self.view addSubview:self.collectionView];
    _pageControl = [[GCTUIPageControl alloc] initWithFrame:[self pageControlFrame]];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    self.titleLabel.text = @"normal circle";
    

}

- (IBAction)normalClick:(id)sender {
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    
    _pageControl = [[GCTUIPageControl alloc] initWithFrame:[self pageControlFrame]];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = (NSInteger)(_collectionView.contentOffset.x/CGRectGetWidth(_collectionView.frame)) % 5;
    [self.view addSubview:_pageControl];
    self.titleLabel.text = @"normal circle";

}
- (IBAction)circleClick:(id)sender {
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    _pageControl = [[GCTUIAnimatedPageControl alloc] initWithFrame:[self pageControlFrame]];
    _pageControl.numberOfPages = 5;
    if (self.circle) {
        if ([self.pageControl isKindOfClass:GCTUIAnimatedPageControl.class]) {
            ((GCTUIAnimatedPageControl *)_pageControl).circleAnimation = YES;
        }
    }
    _pageControl.currentPage = (NSInteger)(_collectionView.contentOffset.x/CGRectGetWidth(_collectionView.frame)) % 5;
    [self.view addSubview:_pageControl];
    self.titleLabel.text = @"circle animated";

}
- (IBAction)jerkyClick:(id)sender {
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    _pageControl = [[GCTUIJerkyPageControl alloc] initWithFrame:[self pageControlFrame]];
    _pageControl.numberOfPages = 5;
    if (self.circle) {
        if ([self.pageControl isKindOfClass:GCTUIAnimatedPageControl.class]) {
            ((GCTUIAnimatedPageControl *)_pageControl).circleAnimation = YES;
        }
    }
    _pageControl.currentPage = (NSInteger)(_collectionView.contentOffset.x/CGRectGetWidth(_collectionView.frame)) % 5;
    [self.view addSubview:_pageControl];
    self.titleLabel.text = @"Jerky";

}
- (IBAction)changeCollectionViewClick:(id)sender {
    if (!self.circle) {
        self.numberPages = 5 * 1000;
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointMake(5 * 500 * CGRectGetWidth(self.collectionView.bounds), 0);
    } else {
        self.numberPages = 5;
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    self.pageControl.currentPage = 0;
    if ([self.pageControl isKindOfClass:GCTUIAnimatedPageControl.class]) {
        ((GCTUIAnimatedPageControl *)_pageControl).circleAnimation = YES;
    }
    self.circle = !self.circle;

}

- (CGRect)pageControlFrame {
    return CGRectMake(0, CGRectGetMinY(self.collectionView.frame) + CGRectGetHeight(self.collectionView.frame) - 20, CGRectGetWidth(self.collectionView.frame), 20);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberPages;
    
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"%@ ---- %@", @(indexPath.section), @(indexPath.item)];
    cell.title = title;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    if (currentIndexPath) {
        self.pageControl.currentPage = currentIndexPath.item % 5;
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.pageControl isKindOfClass:GCTUIAnimatedPageControl.class]) {
        [((GCTUIAnimatedPageControl *)self.pageControl) followScrollViewDidScroll:scrollView];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
 
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   

}

#pragma mark - Setter/Getter



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  100, CGRectGetWidth(self.view.bounds), 200) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor grayColor];
        [_collectionView registerClass:DemoCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 200);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    
    return _flowLayout;
}

@end
