//
//  MCCoverageChartView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCCoverageChartView.h"
#import "MCCoverageLayer.h"

#define COVERAGE_CHART_PADDING 16.0

#define COVERAGE_INFO_WIDTH 16.0
#define COVERAGE_INFO_HEIGHT 16.0
#define COVERAGE_INFO_PADDING 16.0
 
@interface MCCoverageChartView ()

@property (nonatomic, assign) NSInteger numberOfCoverage;
@property (nonatomic, strong) NSMutableArray *chartDataSource;

@property (nonatomic, strong) NSMutableArray *coverageColors;

@property (nonatomic, assign) CGFloat cacheMaxValue;

@end

@implementation MCCoverageChartView

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
    self.backgroundColor = [UIColor clearColor];
    
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _maxRadius = MIN(CGRectGetWidth(self.bounds)/2 - COVERAGE_CHART_PADDING, CGRectGetHeight(self.bounds)/2 - COVERAGE_CHART_PADDING);
    _minRadius = 0;
    
    _cacheMaxValue = -1.0f;
}

- (CGFloat)cacheMaxValue {
    if (_cacheMaxValue == -1.0f) {
        _cacheMaxValue = [_maxValue floatValue];
        for (id value in _chartDataSource) {
            _cacheMaxValue = MAX([value floatValue], _cacheMaxValue);
        }
    }
    return _cacheMaxValue;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _maxRadius, 0, 2 * M_PI, 0);
    CGContextStrokePath(context);
    
    if (_minRadius != 0 && ![self.delegate respondsToSelector:@selector(centerViewInCoverageChartView:)] && [self.delegate respondsToSelector:@selector(centerTitleInCoverageChartView:)]) {
        NSAttributedString *title = [self.delegate centerTitleInCoverageChartView:self];
        CGSize titleSize = [title size];
        [title drawInRect:CGRectMake(_centerPoint.x - titleSize.width, _centerPoint.y - titleSize.height, titleSize.width, titleSize.height)];
    }
    
    if (_showCoverageInfo) {
        CGFloat yOffset = _centerPoint.y - _maxRadius;
        CGFloat xOffset = _centerPoint.x + _maxRadius + COVERAGE_INFO_PADDING;
        for (NSInteger index = 0; index < _coverageColors.count; index ++) {
            CGContextSetFillColorWithColor(context, [_coverageColors[index] CGColor]);
            CGContextFillRect(context, CGRectMake(xOffset, yOffset, COVERAGE_INFO_WIDTH, COVERAGE_INFO_HEIGHT));
            
            if ([self.dataSource respondsToSelector:@selector(coverageChartView:attributedTitleOfCoverageAtIndex:)]) {
                NSAttributedString *title = [self.dataSource coverageChartView:self attributedTitleOfCoverageAtIndex:index];
                CGSize titleSize = title.size;
                [title drawInRect:CGRectMake(xOffset + COVERAGE_INFO_WIDTH + 2, yOffset + (COVERAGE_INFO_HEIGHT - titleSize.height)/2, titleSize.width, titleSize.height)];
            } else if ([self.dataSource respondsToSelector:@selector(coverageChartView:titleOfCoverageAtIndex:)]) {
                NSAttributedString *title = [[NSAttributedString alloc] initWithString:[self.dataSource coverageChartView:self titleOfCoverageAtIndex:index] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:COVERAGE_INFO_HEIGHT], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                CGSize titleSize = title.size;
                [title drawInRect:CGRectMake(xOffset + COVERAGE_INFO_WIDTH + 2, yOffset + (COVERAGE_INFO_HEIGHT - titleSize.height)/2, titleSize.width, titleSize.height)];
            }
            
            yOffset += 3 * COVERAGE_INFO_HEIGHT/2;
        }
    }
}

- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfCoverageInCoverageChartView:)], @"You must implemetation the 'numberOfCoverageInCoverageChartView:' method");
    NSAssert([self.dataSource respondsToSelector:@selector(coverageChartView:valueOfCoverageAtIndex:)], @"You must implemetation the 'coverageChartView:valueOfCoverageAtIndex:' method");
    NSInteger numberOfCoverage = [self.dataSource numberOfCoverageInCoverageChartView:self];
    
    _chartDataSource = [[NSMutableArray alloc] initWithCapacity:numberOfCoverage];
    _coverageColors = [NSMutableArray arrayWithCapacity:numberOfCoverage];
    for (NSInteger index = 0; index < numberOfCoverage; index ++) {
        [_chartDataSource addObject:[self.dataSource coverageChartView:self valueOfCoverageAtIndex:index]];
        
        UIColor *coverageColor = [UIColor colorWithRed:(index + 1.0)/numberOfCoverage green:1 - (index + 1.0)/numberOfCoverage blue:index * 1.0/numberOfCoverage alpha:1.0];
        if ([self.delegate respondsToSelector:@selector(coverageChartView:colorOfCoverageAtIndex:)]) {
            coverageColor = [self.delegate coverageChartView:self colorOfCoverageAtIndex:index];
        }
        [_coverageColors addObject:coverageColor];
    }
    
    CGFloat startAngle = 3 * M_PI_2;
    CGFloat endAngle = 3 * M_PI_2;
    for (NSInteger index = 0; index < numberOfCoverage; index ++) {
        endAngle = startAngle - 2 * M_PI/numberOfCoverage;
        MCCoverageLayer *coverageLayer = [[MCCoverageLayer alloc] init];
        coverageLayer.startAngle = startAngle;
        coverageLayer.endAngle = endAngle;
        coverageLayer.coverageColor = [_coverageColors[index] CGColor];
        coverageLayer.minRadius = _minRadius;
        coverageLayer.maxRadius = [_chartDataSource[index] floatValue]/self.cacheMaxValue * (_maxRadius - _minRadius) + _minRadius;
        coverageLayer.centerPoint = _centerPoint;
        coverageLayer.frame = self.bounds;
        [self.layer addSublayer:coverageLayer];
        
        [coverageLayer reloadRadiusWithAnimate:animate duration:coverageLayer.maxRadius/_maxRadius * 0.75];
        
        startAngle = endAngle;
    }

    if ([self.delegate respondsToSelector:@selector(centerViewInCoverageChartView:)] && _minRadius != 0) {
        UIView *view = [self.delegate centerViewInCoverageChartView:self];
        CGFloat scale = MAX(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))/_minRadius;
        view.transform = CGAffineTransformMakeScale(scale, scale);
        view.center = _centerPoint;
        [self addSubview:view];
    }
}

@end
