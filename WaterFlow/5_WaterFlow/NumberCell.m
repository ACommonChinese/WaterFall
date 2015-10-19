//
//  NumberCell.m
//  5_WaterFlow
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import "NumberCell.h"

@implementation NumberCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end


