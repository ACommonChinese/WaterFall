//
//  WaterFowLayout.h
//  5_WaterFlow
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

// 代理方法告诉我：item的高度
- (CGFloat)waterfallLayout:(WaterFowLayout *)layout heightAtIndexPath:(NSIndexPath*)indexPath;

@end


@interface WaterFowLayout : UICollectionViewLayout

// 指定有多少列
@property(nonatomic) NSInteger columNumber;

// 指定item之间的间隙
@property(nonatomic) CGFloat interSpaceing;

//指定每一个段(section)的内边距
@property(nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic, assign) id<WaterFlowLayoutDelegate> delegate; // 这个代理负责告诉我“每个item高是多少”

@end




