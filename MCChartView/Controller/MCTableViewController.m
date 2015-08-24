//
//  MCTableViewController.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCTableViewController.h"
#import "MCBarChartViewController.h"
#import "MCLineChartViewController.h"
#import "MCPieChartViewController.h"
#import "MCRadarChartViewController.h"
#import "MCCircleChartViewController.h"
#import "MCCoverageChartViewController.h"

@interface MCTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    _dataSource = @[@"Bar Chart", @"Line Chart", @"Pie Chart", @"Radar Chart", @"Circle Chart", @"Coverage Chart"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        MCBarChartViewController *viewController = [[MCBarChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        MCLineChartViewController *viewController = [[MCLineChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 2) {
        MCPieChartViewController *viewController = [[MCPieChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 3) {
        MCRadarChartViewController *viewController = [[MCRadarChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 4) {
        MCCircleChartViewController *viewController = [[MCCircleChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 5) {
        MCCoverageChartViewController *viewController = [[MCCoverageChartViewController alloc] init];
        viewController.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
