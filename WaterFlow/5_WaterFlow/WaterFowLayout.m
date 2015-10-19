//
//  WaterFowLayout.m
//  5_WaterFlow
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import "WaterFowLayout.h"

@interface WaterFowLayout ()

// 该数组中，包含的是每一列当前布局到的高度
// 把新过来的cell放在高度最低的那一列
@property(nonatomic) NSMutableArray *columHeightArray;

// 布局信息
@property(nonatomic) NSMutableArray *attributesArray;
@end

@implementation WaterFowLayout

// 列数发生了变化，重新排版
- (void)setColumNumber:(NSInteger)columNumber {
    if (_columNumber != columNumber) {
        _columNumber = columNumber;
        //layout失效，需要重新布局
        [self invalidateLayout]; // 自动调prepareLayout
    }
}

// cell之间的间距发生了变化，重新排版
- (void)setInterSpaceing:(CGFloat)interSpaceing {
    if (_interSpaceing != interSpaceing) {
        _interSpaceing = interSpaceing;
        [self invalidateLayout];
    }
}

// section的内边距发生了变化，重新排版
- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) { // 判断两个rect是否相同
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

//自己定义layout 需要重写下面几个方法
- (void)prepareLayout {
    [super prepareLayout];
    self.attributesArray  = [NSMutableArray array];
    self.columHeightArray = [NSMutableArray arrayWithCapacity:self.columNumber]; // columNumber是由外部传过来的，因为“我”不知道有多少列，外部把它传过来
    
    // 初始化数组columHeightArray高度
    for (int index = 0; index < self.columNumber; index++) {
        self.columHeightArray[index] = @(self.sectionInset.top);
    }
    
    // 总宽度
    CGFloat totalWith = self.collectionView.bounds.size.width;
    
    // 可用宽度
    CGFloat validWidth = (totalWith-self.sectionInset.left-self.sectionInset.right-self.interSpaceing*(self.columNumber-1));
    
    // 计算出每一个item的宽度
    CGFloat itemWith = validWidth/self.columNumber;
    
    // 对item排版 （其实就是生成item对应的排版属性对象：UICollectionViewLayoutAttributes）
    // 得到collectionView得到有多少个item
    NSInteger totalItems = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < totalItems; i++) {
        // 找到最短的那一列(索引值，即第几列)，生成布局对象放在这个最短的这一列的下面
        NSInteger currentColumn = [self findShortestColumHeight];
        CGFloat xPos = self.sectionInset.left + (itemWith+self.interSpaceing)*currentColumn;
        CGFloat yPos = [self.columHeightArray[currentColumn] floatValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 由代理告诉我， “item有多高”
        CGFloat itemHeight = [self.delegate waterfallLayout:self heightAtIndexPath:indexPath];
        CGRect frame = CGRectMake(xPos, yPos, itemWith, itemHeight);
        
        // 生成针对cell的布局属性类对象，一个布局类对象决定了一个cell的布局
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 针对哪个indexPath生成一个空的attributes
        attributes.frame = frame;
        [self.attributesArray addObject:attributes];
        
        // 更新当前列的高度
        CGFloat updateYPos = [self.columHeightArray[currentColumn] floatValue] + itemHeight+self.interSpaceing;
        self.columHeightArray[currentColumn] = @(updateYPos);
    }
}

// 系统传递过来一个区域rect，我们需要返回在该区域中的item的位置信息
// 返回的是一个数组，数组中包含UICollectionViewLayoutAttributes 对象
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.attributesArray) {
        CGRect frame = attributes.frame;
        if (CGRectIntersectsRect(frame, rect)) {
            [resultArray addObject:attributes];
        }
    }
    return resultArray;
}

// UICollectionViewLayoutAttributes 该对象保存每一个cell的位置
// 根据指定的indexPath返回该indexPath对应的cell的位置信息
- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.attributesArray objectAtIndex:indexPath.item];
}

// 由于UICollectionVeiw继承自UIScrollView，所以需要重写该函数，告诉contentSize大小
- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    NSInteger currentIndex = [self findLongestColumnIndex];
    CGFloat contentHeight = [self.columHeightArray[currentIndex] floatValue];
    return CGSizeMake(contentWidth, contentHeight);
}

// 找最长的列的索引
- (NSInteger)findLongestColumnIndex {
    __block NSInteger index = 0;
    __block CGFloat longestHeight = 0;
    [self.columHeightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat heightInArray = [obj floatValue];
        if (heightInArray > longestHeight) {
            longestHeight = heightInArray;
            index = idx;
        }
    }];
    
    return index;
}


// 找到最短的那一列的索引 0 1 2
- (NSInteger)findShortestColumHeight {
    __block NSInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    [self.columHeightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj floatValue] < shortestHeight) {
            shortestHeight = [obj floatValue];
            index = idx;
        }
    }];
    return index;
}

@end






