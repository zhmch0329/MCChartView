//
//  MCPieChartView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCPieChartView.h"

#define PIE_CHART_PADDING 16.0

@interface MCPieChartView ()

@property (nonatomic, strong) NSMutableArray *chartDataSource;

@end

@implementation MCPieChartView

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
    _radius = MIN(CGRectGetWidth(self.bounds)/2 - PIE_CHART_PADDING, CGRectGetHeight(self.bounds)/2 - PIE_CHART_PADDING);
    
    _pieBackgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:118/255.0 alpha:1.0];
    
    _ring = YES;
    _ringWidth = _radius;
    _circle = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    if (![self.delegate respondsToSelector:@selector(ringViewInPieChartView:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        if ([self.delegate respondsToSelector:@selector(ringTitleInPieChartView:)]) {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:[self.delegate ringTitleInPieChartView:self]];
            [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
            CGSize titleSize = [title size];
            CGRect titleRect = CGRectMake(_centerPoint.x - titleSize.width/2, _centerPoint.y - titleSize.height/2, titleSize.width, titleSize.height);
            [title drawInRect:titleRect];
        } else if (_ringTitle.length > 0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:_ringTitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: paragraphStyle}];
            CGSize titleSize = [title size];
            CGRect titleRect = CGRectMake(_centerPoint.x - titleSize.width/2, _centerPoint.y - titleSize.height/2, titleSize.width, titleSize.height);
            [title drawInRect:titleRect];
        }
    }
}

- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfPieInPieChartView:)], @"You must implemetation the 'numberOfPieInPieChartView:' method");
    NSAssert([self.dataSource respondsToSelector:@selector(pieChartView:valueOfPieAtIndex:)], @"You must implemetation the 'pieChartView:valueOfPieAtIndex:' method");
    NSInteger numberOfPie = [self.dataSource numberOfPieInPieChartView:self];
    _chartDataSource = [NSMutableArray arrayWithCapacity:numberOfPie];
    for (NSInteger index = 0; index < numberOfPie; index ++) {
        id value = [self.dataSource pieChartView:self valueOfPieAtIndex:index];
        [_chartDataSource addObject:value];
    }
    CGFloat sumValue = 0.0;
    if ([self.dataSource respondsToSelector:@selector(sumValueInPieChartView:)]) {
        sumValue = [[self.dataSource sumValueInPieChartView:self] floatValue];
    } else if (_circle) {
        for (id value in _chartDataSource) {
            sumValue += [value floatValue];
        }
    } else {
        NSAssert([self.dataSource respondsToSelector:@selector(sumValueInPieChartView:)], @"You must have a sumValue");
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius - _ringWidth/2 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = _ringWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = _pieBackgroundColor.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    CGFloat startAngle = 3 * M_PI_2;
    CGFloat endAngle = 0.0;
    for (NSInteger index = 0; index < numberOfPie; index ++) {
        endAngle = startAngle - [_chartDataSource[index] floatValue]/sumValue * 2 * M_PI;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius - _ringWidth/2 startAngle:startAngle endAngle:endAngle clockwise:NO];
        
        UIColor *pieColor = [UIColor colorWithRed:(index + 1.0)/numberOfPie green:1 - (index + 1.0)/numberOfPie blue:index * 1.0/numberOfPie alpha:1.0];
        if ([self.delegate respondsToSelector:@selector(pieChartView:colorOfPieAtIndex:)]) {
            pieColor = [self.delegate pieChartView:self colorOfPieAtIndex:index];
        }
        
        if (animate) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3 * M_PI_2 - startAngle)/(2 * M_PI) * 1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.lineWidth = _ringWidth;
                shapeLayer.fillColor = [UIColor clearColor].CGColor;
                shapeLayer.strokeColor = pieColor.CGColor;
                shapeLayer.path = bezierPath.CGPath;
                [self.layer addSublayer:shapeLayer];
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = @(0.0);
                animation.toValue = @(1.0);
                animation.repeatCount = 1.0;
                animation.duration = (startAngle - endAngle)/(2 * M_PI) * 1.5;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [shapeLayer addAnimation:animation forKey:@"animation"];
            });
        } else {
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.lineWidth = _ringWidth;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.strokeColor = pieColor.CGColor;
            shapeLayer.path = bezierPath.CGPath;
            [self.layer addSublayer:shapeLayer];
        }

        
        startAngle = endAngle;
    }
    
    if ([self.delegate respondsToSelector:@selector(ringViewInPieChartView:)]) {
        UIView *view = [self.delegate ringViewInPieChartView:self];
        view.center = CGPointMake(_centerPoint.x, _centerPoint.y);
        [self addSubview:view];
    }
    
    [self setNeedsDisplay];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}

@end
