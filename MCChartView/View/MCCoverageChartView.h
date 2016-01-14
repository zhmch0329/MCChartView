//
//  MCCoverageChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCoverageChartView;
@protocol MCCoverageChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfCoverageInCoverageChartView:(MCCoverageChartView *)coverageChartView;
- (id)coverageChartView:(MCCoverageChartView *)coverageChartView valueOfCoverageAtIndex:(NSInteger)index;

@optional
- (NSString *)coverageChartView:(MCCoverageChartView *)coverageChartView titleOfCoverageAtIndex:(NSInteger)index;
- (NSAttributedString *)coverageChartView:(MCCoverageChartView *)coverageChartView attributedTitleOfCoverageAtIndex:(NSInteger)index;

@end

@protocol MCCoverageChartViewDelegate <NSObject>

@optional
- (UIColor *)coverageChartView:(MCCoverageChartView *)coverageChartView colorOfCoverageAtIndex:(NSInteger)index;
- (NSAttributedString *)centerTitleInCoverageChartView:(MCCoverageChartView *)coverageChartView;
- (UIView *)centerViewInCoverageChartView:(MCCoverageChartView *)coverageChartView;

@end

@interface MCCoverageChartView : UIView

@property (nonatomic, weak) id<MCCoverageChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCCoverageChartViewDelegate> delegate;

/// 中心点位置
@property (nonatomic, assign) CGPoint centerPoint;
/// 最大半径
@property (nonatomic, assign) CGFloat maxRadius;
/// 最小半径，默认为：0
@property (nonatomic, assign) CGFloat minRadius;

/// 设置数据最大值
@property (nonatomic, strong) id maxValue;

@property (nonatomic, assign) BOOL showCoverageInfo;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
