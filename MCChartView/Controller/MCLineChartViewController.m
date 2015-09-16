//
//  MCLineChartViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/18.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCLineChartViewController.h"
#import "MCLineChartView.h"

@interface MCLineChartViewController () <MCLineChartViewDataSource, MCLineChartViewDelegate>

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) MCLineChartView *lineChartView;

@end

@implementation MCLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titles = @[@"第一次月考", @"第二次月考", @"第三次月考", @"第四次月考", @"第五次月考"];
    _dataSource = @[@100, @245, @180, @165, @225];
    
    _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    _lineChartView.dotRadius = 10;
    _lineChartView.oppositeY = YES;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @1;
    _lineChartView.maxValue = @700;
    _lineChartView.solidDot = YES;
    _lineChartView.numberOfYAxis = 7;
    _lineChartView.colorOfXAxis = [UIColor whiteColor];
    _lineChartView.colorOfXText = [UIColor whiteColor];
    _lineChartView.colorOfYAxis = [UIColor whiteColor];
    _lineChartView.colorOfYText = [UIColor whiteColor];
    [self.view addSubview:_lineChartView];
    
    [_lineChartView reloadDataWithAnimate:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i ++) {
        [mutableArray addObject:@(arc4random()%700)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    [_lineChartView reloadData];
}

- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    return [_dataSource count];
}

- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    return _dataSource[index];
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
    return _titles[number];
}

- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    if (lineNumber == 0) {
        return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    } else if (lineNumber == 1) {
        return [UIColor lightGrayColor];
    } else if (lineNumber == 2) {
        return [UIColor redColor];
    } else {
        return [UIColor yellowColor];
    }
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    if (index == 0 || index == _dataSource.count - 1) {
        return [NSString stringWithFormat:@"%@名", _dataSource[index]];
    }
    return nil;
}

@end
