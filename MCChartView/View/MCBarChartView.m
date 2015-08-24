//
//  MCBarChartView.m
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCBarChartView.h"
#import "MCChartInformationView.h"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)

#define BAR_CHART_TOP_PADDING 30
#define BAR_CHART_LEFT_PADDING 40
#define BAR_CHART_RIGHT_PADDING 8
#define BAR_CHART_TEXT_HEIGHT 40

#define BAR_WIDTH_DEFAULT 20.0

#define PADDING_SECTION_DEFAULT 10.0
#define PADDING_BAR_DEFAULT 1.0

CGFloat static const kChartViewUndefinedCachedHeight = -1.0f;

@interface MCBarChartView ()

@property (nonatomic, strong) NSArray *chartDataSource;

@property (nonatomic, assign) NSUInteger sections;
@property (nonatomic, assign) CGFloat paddingSection;
@property (nonatomic, assign) CGFloat paddingBar;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;

@end

@implementation MCBarChartView {
    UIColor *_chartBackgroundColor;
    UIScrollView *_scrollView;
    
    CGFloat _chartHeight;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.bounds.size.width;
    _chartHeight = self.bounds.size.height - BAR_CHART_TOP_PADDING - BAR_CHART_TEXT_HEIGHT;
    
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BAR_CHART_LEFT_PADDING, 0, width - BAR_CHART_RIGHT_PADDING - BAR_CHART_LEFT_PADDING, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateWithContext:context];
}

#pragma mark - Draw Coordinate

- (void)drawCoordinateWithContext:(CGContextRef)context {
    CGFloat width = self.bounds.size.width;
    
    CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING - 1);
    CGContextAddLineToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - BAR_CHART_RIGHT_PADDING + 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
}

#pragma mark - Height

- (CGFloat)normalizedHeightForRawHeight:(NSNumber *)rawHeight {
    CGFloat value = [rawHeight floatValue];
    CGFloat maxHeight = [self.maxValue floatValue];
    return value/maxHeight * _chartHeight;
}

- (id)maxValue {
    if (_maxValue == nil) {
        if ([self cachedMaxHeight] != kChartViewUndefinedCachedHeight) {
            _maxValue = @([self cachedMaxHeight]);
        }
    }
    return _maxValue;
}

- (CGFloat)cachedMinHeight {
    if(_cachedMinHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height < _cachedMinHeight) {
                    _cachedMinHeight = height;
                }
            }
        }
    }
    return _cachedMinHeight;
}

- (CGFloat)cachedMaxHeight {
    if (_cachedMaxHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height > _cachedMaxHeight) {
                    _cachedMaxHeight = height;
                }
            }
        }
    }
    return _cachedMaxHeight;
}

#pragma mark - Reload Data
- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self reloadChartDataSource];
    [self reloadChartYAxis];
    [self reloadBarWithAnimate:animate];
}

- (void)reloadChartDataSource {
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInBarChartView:)]) {
        _sections = [self.dataSource numberOfSectionsInBarChartView:self];
    }
    
    NSAssert([self.dataSource respondsToSelector:@selector(barChartView:numberOfBarsInSection:)], @"BarChartView // delegate must implement barChartView:numberOfBarsInSection:");
    
    _paddingSection = PADDING_SECTION_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(paddingForSectionInBarChartView:)]) {
        _paddingSection = [self.delegate paddingForSectionInBarChartView:self];
    }
    _paddingBar = PADDING_BAR_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(paddingForBarInBarChartView:)]) {
        _paddingBar = [self.delegate paddingForBarInBarChartView:self];
    }
    _barWidth = BAR_WIDTH_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(barWidthInBarChartView:)]) {
        _barWidth = [self.delegate barWidthInBarChartView:self];
    }
    
    NSAssert(([self.dataSource respondsToSelector:@selector(barChartView:valueOfBarInSection:index:)]), @"MCBarChartView // delegate must implement - (CGFloat)barChartView:(MCBarChartView *)barChartView valueOfBarsInSection:(NSUInteger)section index:(NSUInteger)index");
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_sections];
    CGFloat contentWidth = _paddingSection;
    for (NSUInteger i = 0; i < _sections; i ++) {
        NSUInteger barCount = [self.dataSource barChartView:self numberOfBarsInSection:i];

        contentWidth += barCount * _barWidth + (barCount - 1) * _paddingBar;
        contentWidth += _paddingSection;
        
        NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:barCount];
        for (NSInteger j = 0; j < barCount; j ++) {
            id value = [self.dataSource barChartView:self valueOfBarInSection:i index:j];
            [barArray addObject:value];
        }
        [dataArray addObject:barArray];
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    _chartDataSource = [[NSMutableArray alloc] initWithArray:dataArray];
}

- (void)reloadChartYAxis {
    CGFloat chartYOffset = _chartHeight + BAR_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight/_numberOfYAxis;
    CGFloat unitValue = [self.maxValue floatValue]/_numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - unitHeight * i - 10, BAR_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f%@", unitValue * i, _unitOfYAxis];
        [self addSubview:textLabel];
    }
}

- (void)reloadBarWithAnimate:(BOOL)animate {
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat xSection = _paddingSection;
    CGFloat xOffset = _paddingSection + _barWidth/2;
    CGFloat chartYOffset = _chartHeight + BAR_CHART_TOP_PADDING;
    for (NSInteger section = 0; section < _sections; section ++) {
        NSArray *array = _chartDataSource[section];
        for (NSInteger index = 0; index < array.count; index ++) {
            CGFloat height = [self normalizedHeightForRawHeight:array[index]];
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(xOffset, chartYOffset)];
            [bezierPath addLineToPoint:CGPointMake(xOffset, chartYOffset - height)];
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.lineWidth = _barWidth;
            shapeLayer.path = bezierPath.CGPath;
            
            if ([self.delegate respondsToSelector:@selector(barChartView:colorOfBarInSection:index:)]) {
                shapeLayer.strokeColor = [self.delegate barChartView:self colorOfBarInSection:section index:index].CGColor;
            } else {
                shapeLayer.strokeColor = [UIColor redColor].CGColor;
            }
            [_scrollView.layer addSublayer:shapeLayer];
            
            if (animate) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = @(0.0);
                animation.toValue = @(1.0);
                animation.repeatCount = 1.0;
                animation.duration = height/_chartHeight * 0.75;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [shapeLayer addAnimation:animation forKey:@"animation"];
            }
            
            NSTimeInterval delay = animate ? 0.75 : 0.0;
            if ([self.delegate respondsToSelector:@selector(barChartView:hintViewOfBarInSection:index:)]) {
                UIView *hintView = [self.delegate barChartView:self hintViewOfBarInSection:section index:index];
                if (hintView) {
                    hintView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(hintView.bounds)/2);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            } else if ([self.delegate respondsToSelector:@selector(barChartView:informationOfBarInSection:index:)]) {
                NSString *information = [self.delegate barChartView:self informationOfBarInSection:section index:index];
                if (information) {
                    MCChartInformationView *informationView = [[MCChartInformationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(informationView.bounds)/2);
                    informationView.alpha = 0.0;
                    [_scrollView addSubview:informationView];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            xOffset += _barWidth + (index == array.count - 1 ? 0 : _paddingBar);
        }
        
        if ([self.delegate respondsToSelector:@selector(barChartView:titleOfBarInSection:)]) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSection - _paddingSection/2, _chartHeight + BAR_CHART_TOP_PADDING, xOffset - xSection + _paddingSection, BAR_CHART_TEXT_HEIGHT)];
            textLabel.textColor = _colorOfXText;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.numberOfLines = 0;
            textLabel.text = [self.dataSource barChartView:self titleOfBarInSection:section];
            [_scrollView addSubview:textLabel];
        }
        xOffset += _paddingSection;
        xSection = xOffset;
    }
}

@end
