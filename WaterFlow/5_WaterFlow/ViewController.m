//
//  ViewController.m
//  5_WaterFlow
//
//  Created by liuweizhen on 15/10/15.
//  Copyright (c) 2015年 愤怒的振振. All rights reserved.
//

#import "ViewController.h"
#import "WaterFowLayout.h"
#import "NumberCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WaterFlowLayoutDelegate>
{
    UICollectionView *_collectionView;
}

@property (nonatomic) NSInteger count; // 有多少个cell
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.count = 200;
    
    [self createCollectionView];
    
    [self addMoreButton];
}

- (void)addMoreButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    self.count += 10;
    [_collectionView reloadData];
}

- (void)createCollectionView {
    WaterFowLayout *layout = [[WaterFowLayout alloc] init];
    layout.columNumber     = 3; // 3列
    layout.sectionInset    = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interSpaceing   = 5;
    layout.delegate        = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[NumberCell class] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionView 代理
// 有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    cell.label.font = [UIFont boldSystemFontOfSize:30];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

#pragma mark - <WaterFlowLayoutDelegate>
- (CGFloat)waterfallLayout:(WaterFowLayout *)layout heightAtIndexPath:(NSIndexPath*)indexPath {
    return 100.0 + arc4random()%161; //100 ~ 260
}

@end






