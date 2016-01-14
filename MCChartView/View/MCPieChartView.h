//
//  MCPieChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCPieChartView;
@protocol MCPieChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfPieInPieChartView:(MCPieChartView *)pieChartView;
- (id)pieChartView:(MCPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index;

@optional
- (id)sumValueInPieChartView:(MCPieChartView *)pieChartView;

@end

@protocol MCPieChartViewDelegate <NSObject>

@optional
- (UIColor *)pieChartView:(MCPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index;
- (NSAttributedString *)ringTitleInPieChartView:(MCPieChartView *)pieChartView;
- (UIView *)ringViewInPieChartView:(MCPieChartView *)pieChartView;

@end

@interface MCPieChartView : UIView

@property (nonatomic, weak) id<MCPieChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCPieChartViewDelegate> delegate;

/// 中心点的位置
@property (nonatomic, assign) CGPoint centerPoint;
/// 半径大小
@property (nonatomic, assign) CGFloat radius;
/// 扇形区域背景色
@property (nonatomic, strong) UIColor *pieBackgroundColor;

/// 默认值为半径值，小于半径时为圆环
@property (nonatomic, assign) CGFloat ringWidth;
/// 圆环时显示标题，14号黑色字
@property (nonatomic, copy) NSString *ringTitle;
/// 是否为全圆，非全圆时需设置数据总和
@property (nonatomic, assign) BOOL circle;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
