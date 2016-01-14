//
//  MCCircleChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCircleChartView;
@protocol MCCircleChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfCircleInCircleChartView:(MCCircleChartView *)circleChartView;
- (id)circleChartView:(MCCircleChartView *)circleChartView valueOfCircleAtIndex:(NSInteger)index;

@optional
- (NSString *)circleChartView:(MCCircleChartView *)circleChartView introduceAtIndex:(NSInteger)index;

@end

@protocol MCCircleChartViewDelegate <NSObject>

@optional
- (UIColor *)circleChartView:(MCCircleChartView *)circleChartView colorOfCircleAtIndex:(NSInteger)index;
- (NSAttributedString *)titleInCircleChartView:(MCCircleChartView *)circleChartView;
- (UIView *)centerViewInCircleChartView:(MCCircleChartView *)circleChartView;

@end

@interface MCCircleChartView : UIView

@property (nonatomic, weak) id<MCCircleChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCCircleChartViewDelegate> delegate;

/// 圆弧的中心点
@property (nonatomic, assign) CGPoint centerPoint;
/// 圆弧的最大角度，默认为：M_PI/2 * 3
@property (nonatomic, assign) CGFloat maxAngle;
/// 最大半径
@property (nonatomic, assign) CGFloat maxRadius;
/// 圆弧宽度，默认值16.0
@property (nonatomic, assign) CGFloat circleWidth;
/// 圆弧间距，默认值为1.0
@property (nonatomic, assign) CGFloat circlePadding;

/// 介绍文字大小，默认为：14.0
@property (nonatomic, assign) CGFloat introduceFontSize;
/// 介绍文本字体颜色，默认为黑色
@property (nonatomic, strong) UIColor *introduceColor;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
