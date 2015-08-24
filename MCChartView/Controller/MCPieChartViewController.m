//
//  MCPieChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCPieChartViewController.h"
#import "MCPieChartView.h"

@interface MCPieChartViewController () <MCPieChartViewDataSource, MCPieChartViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MCPieChartView *pieChartView;

@end

@implementation MCPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++) {
        [mutableArray addObject:@(arc4random()%100)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    
    _pieChartView = [[MCPieChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    _pieChartView.dataSource = self;
    _pieChartView.delegate = self;
//    pieChartView.circle = NO;
    _pieChartView.ringTitle = @"简单题\n共300分";
    _pieChartView.ringWidth = 20;
    [self.view addSubview:_pieChartView];
    
    [_pieChartView reloadDataWithAnimate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++) {
        [mutableArray addObject:@(arc4random()%100)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    [_pieChartView reloadData];
}

- (NSInteger)numberOfPieInPieChartView:(MCPieChartView *)pieChartView {
    return _dataSource.count;
}

- (id)pieChartView:(MCPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index {
    return _dataSource[index];
}

- (id)sumValueInPieChartView:(MCPieChartView *)pieChartView {
    return @400;
}

- (NSAttributedString *)ringTitleInPieChartView:(MCPieChartView *)pieChartView {
    return [[NSAttributedString alloc] initWithString:@"简单题\n共300分" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (UIColor *)pieChartView:(MCPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index {
    if (index == 0) {
        return [UIColor colorWithRed:98/255.0 green:147/255.0 blue:215/255.0 alpha:1.0];
    } else if (index == 1) {
        return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
    } else if (index == 2) {
        return [UIColor colorWithRed:224/255.0 green:135/255.0 blue:56/255.0 alpha:1.0];
    }
    return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
}

@end
