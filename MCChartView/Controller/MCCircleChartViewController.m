//
//  MCCircleChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCCircleChartViewController.h"
#import "MCCircleChartView.h"

@interface MCCircleChartViewController () <MCCircleChartViewDataSource, MCCircleChartViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MCCircleChartView *circleChartView;

@end

@implementation MCCircleChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    _dataSource = @[@4, @10, @22, @60, @4];
    
    _circleChartView = [[MCCircleChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
    _circleChartView.introduceColor = [UIColor whiteColor];
    _circleChartView.maxRadius = 140;
    _circleChartView.circleWidth = 24.0;
    _circleChartView.dataSource = self;
    _circleChartView.delegate = self;
    [self.view addSubview:_circleChartView];
    
    [_circleChartView reloadDataWithAnimate:YES];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    _dataSource = @[@7, @20, @13, @19];
    [_circleChartView reloadData];
}

- (NSInteger)numberOfCircleInCircleChartView:(MCCircleChartView *)circleChartView {
    return _dataSource.count;
}

- (id)circleChartView:(MCCircleChartView *)circleChartView valueOfCircleAtIndex:(NSInteger)index {
    return _dataSource[index];
}

- (NSString *)circleChartView:(MCCircleChartView *)circleChartView introduceAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@%%的分数丢失", _dataSource[index]];
}

- (NSAttributedString *)titleInCircleChartView:(MCCircleChartView *)circleChartView {
    return [[NSAttributedString alloc] initWithString:@"共丢失123分\n语文" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (UIColor *)circleChartView:(MCCircleChartView *)circleChartView colorOfCircleAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [UIColor colorWithRed:78/255.0 green:119/255.0 blue:171/255.0 alpha:1.0];
        case 1:
            return [UIColor colorWithRed:98/255.0 green:186/255.0 blue:215/255.0 alpha:1.0];
        case 2:
            return [UIColor colorWithRed:81/255.0 green:209/255.0 blue:183/255.0 alpha:1.0];
        case 3:
            return [UIColor colorWithRed:224/255.0 green:135/255.0 blue:56/255.0 alpha:1.0];
        case 4:
            return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
        default:
            return [UIColor grayColor];
    }
}

@end
