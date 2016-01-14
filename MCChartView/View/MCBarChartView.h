//
//  MCBarChartView.h
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCBarChartView;
@class UITableView;
@protocol MCBarChartViewDataSource <NSObject>

@required
- (NSInteger)barChartView:(MCBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section;
- (id)barChartView:(MCBarChartView *)barChartView valueOfBarInSection:(NSInteger)section index:(NSInteger)index;

@optional
- (NSInteger)numberOfSectionsInBarChartView:(MCBarChartView *)barChartView;
- (NSString *)barChartView:(MCBarChartView *)barChartView titleOfBarInSection:(NSInteger)section;


@end

@protocol MCBarChartViewDelegate <NSObject>

@optional
- (void)barChartView:(MCBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index;

- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView;

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView;
- (CGFloat)paddingForBarInBarChartView:(MCBarChartView *)barChartView;

- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index;
- (NSArray *)barChartView:(MCBarChartView *)barChartView selectionColorForBarInSection:(NSUInteger)section;

- (NSString *)barChartView:(MCBarChartView *)barChartView informationOfBarInSection:(NSInteger)section index:(NSInteger)index;
- (UIView *)barChartView:(MCBarChartView *)barChartView hintViewOfBarInSection:(NSInteger)section index:(NSInteger)index;

@end

@interface MCBarChartView : UIView

@property (nonatomic, weak) id<MCBarChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCBarChartViewDelegate> delegate;

/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位
@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfYText;
/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
