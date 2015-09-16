//
//  MCCoverageChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCCoverageChartViewController.h"
#import "MCCoverageChartView.h"

@interface MCCoverageChartViewController () <MCCoverageChartViewDataSource, MCCoverageChartViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MCCoverageChartView *coverageChartView;

@end

@implementation MCCoverageChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _dataSource = @[@13, @20, @17, @20];
    
    _coverageChartView = [[MCCoverageChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    _coverageChartView.centerPoint = CGPointMake(120, 150);
    _coverageChartView.showCoverageInfo = YES;
    _coverageChartView.maxRadius = 100;
    _coverageChartView.minRadius = 30;
    _coverageChartView.maxValue = @24;
    _coverageChartView.dataSource = self;
    _coverageChartView.delegate = self;
    [self.view addSubview:_coverageChartView];
    
    [_coverageChartView reloadDataWithAnimate:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    _dataSource = @[@7, @20, @13, @19];
    [_coverageChartView reloadData];
}

- (NSInteger)numberOfCoverageInCoverageChartView:(MCCoverageChartView *)coverageChartView {
    return _dataSource.count;
}

- (id)coverageChartView:(MCCoverageChartView *)coverageChartView valueOfCoverageAtIndex:(NSInteger)index {
    return _dataSource[index];
}

- (UIColor *)coverageChartView:(MCCoverageChartView *)coverageChartView colorOfCoverageAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [UIColor colorWithRed:98/255.0 green:147/255.0 blue:215/255.0 alpha:1.0];
        case 1:
            return [UIColor colorWithRed:213/255.0 green:108/255.0 blue:70/255.0 alpha:1.0];
        case 2:
            return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
        case 3:
            return [UIColor colorWithRed:97/255.0 green:84/255.0 blue:168/255.0 alpha:1.0];
        case 4:
            return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
        default:
            return [UIColor grayColor];
    }
}

- (NSString *)coverageChartView:(MCCoverageChartView *)coverageChartView titleOfCoverageAtIndex:(NSInteger)index {
    NSArray *title = @[@"其他", @"粗心", @"掌握不熟练", @"知识点不会"];
    return [NSString stringWithFormat:@"%@%@%%", title[index], _dataSource[index]];
}

@end
