//
//  MCLineChartView.h
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCLineChartView;
@protocol MCLineChartViewDataSource <NSObject>

@required
- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number;
- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

@optional
- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView;
- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number;

@end

@protocol MCLineChartViewDelegate <NSObject>

@optional
- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber;
- (CGFloat)lineChartView:(MCLineChartView *)lineChartView lineWidthWithLineNumber:(NSInteger)lineNumber;

- (CGFloat)dotPaddingInLineChartView:(MCLineChartView *)lineChartView;

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;
- (UIView *)lineChartView:(MCLineChartView *)lineChartView hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

@end

CGFloat static const kChartViewUndefinedValue = -1.0f;

@interface MCLineChartView : UIView

@property (nonatomic, weak) id<MCLineChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCLineChartViewDelegate> delegate;

@property (nonatomic, strong) id minValue;
@property (nonatomic, strong) id maxValue;
@property (nonatomic, assign) NSInteger numberOfYAxis;
@property (nonatomic, copy) NSString *unitOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYText;
@property (nonatomic, assign) CGFloat yFontSize;

@property (nonatomic, assign) BOOL oppositeY;

@property (nonatomic, strong) UIColor *colorOfXAxis;
@property (nonatomic, strong) UIColor *colorOfXText;
@property (nonatomic, assign) CGFloat xFontSize;

@property (nonatomic, assign) BOOL solidDot;
@property (nonatomic, assign) CGFloat dotRadius;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
