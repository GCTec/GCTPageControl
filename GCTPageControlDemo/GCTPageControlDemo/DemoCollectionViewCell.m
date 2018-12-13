//
//  DemoCollectionViewCell.m
//  GCTSegmentDemo
//
//  Created by 罗树新 on 2018/12/8.
//  Copyright © 2018 罗树新. All rights reserved.
//

#import "DemoCollectionViewCell.h"

@interface DemoCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DemoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:30];
    }
    return _titleLabel;
}
@end
