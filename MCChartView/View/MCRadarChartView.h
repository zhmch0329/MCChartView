//
//  MCRadarChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCRadarChartView;
@protocol MCRadarChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfValueInRadarChartView:(MCRadarChartView *)radarChartView;
- (id)radarChartView:(MCRadarChartView *)radarChartView valueAtIndex:(NSInteger)index;

@optional
- (NSAttributedString *)radarChartView:(MCRadarChartView *)radarChartView attributedTitleAtIndex:(NSInteger)index;
- (NSString *)radarChartView:(MCRadarChartView *)radarChartView titleAtIndex:(NSInteger)index;

@end

@interface MCRadarChartView : UIView

@property (nonatomic, weak) id<MCRadarChartViewDataSource> dataSource;

/// 最大值
@property (nonatomic, strong) id maxValue;
/// 最小值
@property (nonatomic, strong) id minValue;
/// 中心点
@property (nonatomic, assign) CGPoint centerPoint;
/// 半径大小
@property (nonatomic, assign) CGFloat radius;
/// 数据层数
@property (nonatomic, assign) NSInteger numberOfLayer;

/// 点半径大小，默认为3.0，若等于0则不显示
@property (nonatomic, assign) CGFloat pointRadius;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;

/// 背景线的宽度
@property (nonatomic, assign) CGFloat radarLineWidth;
/// 背景线的颜色
@property (nonatomic, strong) UIColor *radarStrokeColor;
/// 背景颜色
@property (nonatomic, strong) UIColor *radarFillColor;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
