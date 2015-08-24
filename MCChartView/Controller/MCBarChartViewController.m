//
//  MCBarChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCBarChartViewController.h"
#import "MCBarChartView.h"

@interface MCBarChartViewController () <MCBarChartViewDataSource, MCBarChartViewDelegate>

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) MCBarChartView *barChartView;


@property (strong, nonatomic) NSArray *titles2;
@property (strong, nonatomic) NSMutableArray *dataSource2;
@property (strong, nonatomic) MCBarChartView *barChartView2;

@end

@implementation MCBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titles = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"];
    _dataSource = [NSMutableArray arrayWithArray:@[@120, @115.0, @50, @138, @110, @100]];

    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 111;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = @150;
    _barChartView.unitOfYAxis = @"分";
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.view addSubview:_barChartView];
    
//    [_barChartView reloadData];
    
    _titles2 = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"];
    _dataSource2 = [NSMutableArray arrayWithArray:@[@[@100, @120], @[@100, @115.0], @[@100, @50], @[@100, @138], @[@100, @110], @[@100, @100]]];
    
    _barChartView2 = [[MCBarChartView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView2.tag = 222;
    _barChartView2.dataSource = self;
    _barChartView2.delegate = self;
    _barChartView2.maxValue = @150;
    _barChartView2.unitOfYAxis = @"分";
    _barChartView2.colorOfXAxis = [UIColor whiteColor];
    _barChartView2.colorOfXText = [UIColor whiteColor];
    _barChartView2.colorOfYAxis = [UIColor whiteColor];
    _barChartView2.colorOfYText = [UIColor whiteColor];
    [self.view addSubview:_barChartView2];
    
    [_barChartView2 reloadDataWithAnimate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    [_dataSource removeAllObjects];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        [_dataSource addObject:@(arc4random()%150)];
    }
    [_barChartView reloadData];
    
    [_dataSource2 removeAllObjects];
    for (NSInteger i = 0; i < _titles2.count; i ++) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 2; i ++) {
            [mutableArray addObject:@(arc4random()%150)];
        }
        [_dataSource2 addObject:mutableArray];
    }
    [_barChartView2 reloadData];
}

- (NSInteger)numberOfSectionsInBarChartView:(MCBarChartView *)barChartView {
    if (barChartView.tag == 111) {
        return [_dataSource count];
    } else {
        return [_dataSource count];
    }
    
}

- (NSInteger)barChartView:(MCBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section {
    if (barChartView.tag == 111) {
        return 1;
    } else {
        return [_dataSource2[section] count];
    }
}

- (id)barChartView:(MCBarChartView *)barChartView valueOfBarInSection:(NSInteger)section index:(NSInteger)index {
    if (barChartView.tag == 111) {
        return _dataSource[section];
    } else {
        return _dataSource2[section][index];
    }
}

- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index {
    if (barChartView.tag == 111) {
        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    } else {
        if (index == 0) {
            return [UIColor colorWithRed:105/255.0 green:105/255.0 blue:147/255.0 alpha:1.0];
        }
        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    }
}

- (NSString *)barChartView:(MCBarChartView *)barChartView titleOfBarInSection:(NSInteger)section {
    return _titles[section];
}

- (NSString *)barChartView:(MCBarChartView *)barChartView informationOfBarInSection:(NSInteger)section index:(NSInteger)index {
    if (barChartView.tag == 111) {
        if ([_dataSource[section] floatValue] >= 130) {
            return @"优秀";
        } else if ([_dataSource[section] floatValue] >= 110) {
            return @"良好";
        } else if ([_dataSource[section] floatValue] >= 90) {
            return @"及格";
        } else {
            return @"不及格";
        }
    }
    return nil;
}

- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView {
    if (barChartView.tag == 111) {
        return 26;
    } else {
        return 26;
    }
}

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView {
    if (barChartView.tag == 111) {
        return 24;
    } else {
        return 12;
    }
}

@end
