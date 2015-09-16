//
//  MCRadarChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCRadarChartViewController.h"
#import "MCRadarChartView.h"

@interface MCRadarChartViewController () <MCRadarChartViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MCRadarChartView *radarChartView;

@end

@implementation MCRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titles = @[@"运算求解", @"创新意识", @"应用意识", @"数据处理", @"抽象概括", @"空间想象", @"推理论证"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        [mutableArray addObject:@((arc4random()%100)/100.0)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    
    _radarChartView = [[MCRadarChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
    _radarChartView.dataSource = self;
    _radarChartView.radius = 100;
    _radarChartView.pointRadius = 2;
    _radarChartView.strokeColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    _radarChartView.fillColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:0.2];
    [self.view addSubview:_radarChartView];
    
    [_radarChartView reloadDataWithAnimate:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        [mutableArray addObject:@((arc4random()%100)/100.0)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    [_radarChartView reloadData];
}

- (NSInteger)numberOfValueInRadarChartView:(MCRadarChartView *)radarChartView {
    return _titles.count;
}

- (id)radarChartView:(MCRadarChartView *)radarChartView valueAtIndex:(NSInteger)index {
    return @((arc4random()%100)/100.0);
}

- (NSString *)radarChartView:(MCRadarChartView *)radarChartView titleAtIndex:(NSInteger)index {
    return _titles[index];
}

- (NSAttributedString *)radarChartView:(MCRadarChartView *)radarChartView attributedTitleAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:_titles[index] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
