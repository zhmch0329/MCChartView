//
//  MCRadarChartView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCRadarChartView.h"
#import "MCRadarLayer.h"

#define RADAR_VIEW_PADDING 10.0
#define RADAR_TITLE_PADDING 2.0

@interface MCRadarChartView ()

@property (nonatomic, assign) NSInteger numberOfValue;
@property (nonatomic, strong) NSMutableArray *chartDataSource;

@end

@implementation MCRadarChartView

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
    
    _maxValue = @1;
    _minValue = @0;
    
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _radius = MIN(CGRectGetWidth(self.bounds)/2 - RADAR_VIEW_PADDING * 2, CGRectGetHeight(self.bounds)/2 - RADAR_VIEW_PADDING * 4);
    _numberOfLayer = 4;
    
    _pointRadius = 3.0;
    
    _lineWidth = 1.0;
    _strokeColor = [UIColor greenColor];
    _fillColor = [UIColor clearColor];
    
    _radarLineWidth = 1.0;
    _radarStrokeColor = [UIColor lightGrayColor];
    _radarFillColor = [UIColor whiteColor];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawTitle];
    [self drawRadarWithContext:context];
}

- (void)drawTitle {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    if ([self.dataSource respondsToSelector:@selector(radarChartView:attributedTitleAtIndex:)]) {
        for (NSInteger index = 0; index < _numberOfValue; index ++) {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:[self.dataSource radarChartView:self attributedTitleAtIndex:index]];
            [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
            
            CGPoint radarPoint = [self pointAtIndex:index radius:_radius];
            CGRect titleRect = [self titleRectWithTitle:title radarPoint:radarPoint];
            [title drawInRect:titleRect];
        }
    } else if ([self.dataSource respondsToSelector:@selector(radarChartView:titleAtIndex:)]) {
        for (NSInteger index = 0; index < _numberOfValue; index ++) {
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:[self.dataSource radarChartView:self titleAtIndex:index] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: paragraphStyle}];
            
            CGPoint radarPoint = [self pointAtIndex:index radius:_radius];
            CGRect titleRect = [self titleRectWithTitle:title radarPoint:radarPoint];
            [title drawInRect:titleRect];
        }
    }
}

- (void)drawRadarWithContext:(CGContextRef)context {
    [_radarFillColor setFill];
    [_radarStrokeColor setStroke];
    CGContextSetLineWidth(context, _radarLineWidth);
    CGContextSaveGState(context);
    for (NSInteger layer = 0; layer < _numberOfLayer; layer ++) {
        CGFloat layerRadius = (1 - layer * 1.0/_numberOfLayer) * _radius;
        CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - layerRadius);
        for (NSInteger index = 1; index < _numberOfValue; index ++) {
            CGPoint point = [self pointAtIndex:index radius:layerRadius];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextClosePath(context);
        if (layer == 0) {
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            CGContextStrokePath(context);
        }
    }
    
    for (NSInteger index = 0; index < _numberOfValue; index ++) {
        CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
        CGPoint point = [self pointAtIndex:index radius:_radius];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Private
- (CGPoint)pointAtIndex:(NSInteger)index radius:(CGFloat)radius {
    CGFloat angleOfValue = 2 * M_PI/_numberOfValue;
    return CGPointMake(_centerPoint.x + radius * sin(index * angleOfValue), _centerPoint.y - radius * cos(index * angleOfValue));
}

- (CGRect)titleRectWithTitle:(NSAttributedString *)title radarPoint:(CGPoint)radarPoint {
    CGSize titleSize = [title size];
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    if (radarPoint.x > _centerPoint.x) {
        xOffset = radarPoint.x + RADAR_TITLE_PADDING;
    } else if (radarPoint.x == _centerPoint.x) {
        xOffset = radarPoint.x - titleSize.width/2;
    } else {
        xOffset = radarPoint.x - titleSize.width - RADAR_TITLE_PADDING;
    }
    if (radarPoint.y > _centerPoint.y) {
        yOffset = radarPoint.y;
    } else if (radarPoint.y == _centerPoint.y) {
        yOffset = radarPoint.y - titleSize.height/2;
    } else {
        yOffset = radarPoint.y - titleSize.height;
    }
    return CGRectMake(xOffset, yOffset, titleSize.width, titleSize.height);
}

#pragma mark - Reload Data
- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self reloadChartDataSource];
    [self setNeedsDisplay];
    
    [self reloadRadarWithAnimate:animate];
}

- (void)reloadChartDataSource {
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfValueInRadarChartView:)], @"You must implemetation the 'numberOfValueInRadarChartView:' method");
    NSAssert([self.dataSource respondsToSelector:@selector(radarChartView:valueAtIndex:)], @"You must implemetation the 'radarChartView:valueAtIndex:' method");
    _numberOfValue = [self.dataSource numberOfValueInRadarChartView:self];
    NSAssert(_numberOfValue > 3, @"The return numberOfValue must greater than 3");
    _chartDataSource = [[NSMutableArray alloc] initWithCapacity:_numberOfValue];
    for (NSInteger index = 0; index < _numberOfValue; index ++) {
        id value = [self.dataSource radarChartView:self valueAtIndex:index];
        [_chartDataSource addObject:value];
#ifdef DEBUG
        float floatValue = [value floatValue];
        if (floatValue > [_maxValue floatValue] || floatValue < [_minValue floatValue]) {
            NSAssert([self.dataSource respondsToSelector:@selector(numberOfValueInRadarChartView:)], @"You must let the maxValue greater than any value, and let minValue less than any value!");
        }
#endif
    }
}

- (void)reloadRadarWithAnimate:(BOOL)animate {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    MCRadarLayer *radarLayer = [[MCRadarLayer alloc] init];
    radarLayer.frame = self.bounds;
    radarLayer.pointRadius = _pointRadius;
    radarLayer.fillColor = _fillColor.CGColor;
    radarLayer.strokeColor = _strokeColor.CGColor;
    radarLayer.lineWidth = _lineWidth;
    radarLayer.radarFillColor = _radarFillColor.CGColor;
    radarLayer.centerPoint = _centerPoint;
    
    NSMutableArray *radius = [NSMutableArray arrayWithCapacity:_numberOfValue];
    for (NSInteger i = 0; i < _numberOfValue; i ++) {
        float floatValue = [_chartDataSource[i] floatValue];
        CGFloat layerRadius = floatValue/[_maxValue floatValue] * _radius;
        [radius addObject:@(layerRadius)];
    }
    radarLayer.radius = radius;
    [self.layer addSublayer:radarLayer];
    
    [radarLayer reloadRadiusWithAnimate:animate];
}

@end
