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

@property (nonatomic, strong) id maxValue;
@property (nonatomic, assign) NSInteger numberOfYAxis;
@property (nonatomic, copy) NSString *unitOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYText;

@property (nonatomic, strong) UIColor *colorOfXAxis;
@property (nonatomic, strong) UIColor *colorOfXText;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
