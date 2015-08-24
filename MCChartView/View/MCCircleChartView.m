//
//  MCCircleChartView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCCircleChartView.h"

#define CIRCLE_CHART_PADDING 20

@interface MCCircleChartView ()

@property (nonatomic, assign) CGFloat circleWidth;

@property (nonatomic, assign) NSInteger numberOfCircle;
@property (nonatomic, strong) NSMutableDictionary *chartDataSource;
@property (nonatomic, strong) NSArray *sortKeys;
@property (nonatomic, strong) NSMutableArray *circleColors;

@property (nonatomic, assign) CGFloat cachedMaxValue;
@property (nonatomic, assign) CGFloat cachedMinValue;

@end

@implementation MCCircleChartView

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
    _maxRadius = MIN(CGRectGetWidth(self.bounds)/2 - CIRCLE_CHART_PADDING, CGRectGetHeight(self.bounds)/2 - CIRCLE_CHART_PADDING);
    
    _circlePadding = 1.0;
    
    _maxAngle = M_PI/2 * 3;
    _introduceFontSize = 14.0;
    _introduceColor = [UIColor blackColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat circleWidth = _maxRadius/(_numberOfCircle + 1);
    for (NSInteger index = 0; index < _numberOfCircle; index ++) {
        NSInteger keyIndex = [_sortKeys[index] integerValue];
        
        CGContextSetFillColorWithColor(context, [_circleColors[index] CGColor]);
        CGFloat radius = _maxRadius - circleWidth * index - circleWidth/2;
        CGRect colorRect = CGRectMake(_centerPoint.x + CIRCLE_CHART_PADDING, _centerPoint.y - radius - circleWidth/2 + 2 * _circlePadding, circleWidth, circleWidth - 4 * _circlePadding);
        CGContextAddRect(context, colorRect);
        CGContextFillPath(context);
        
        if ([self.dataSource respondsToSelector:@selector(circleChartView:introduceAtIndex:)]) {
            NSAttributedString *introduce = [[NSAttributedString alloc] initWithString:[self.dataSource circleChartView:self introduceAtIndex:keyIndex] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_introduceFontSize], NSForegroundColorAttributeName: _introduceColor}];
            CGSize introduceSize = [introduce size];
            CGRect introduceRect = CGRectMake(CGRectGetMaxX(colorRect) + 8, CGRectGetMidY(colorRect) - introduce.size.height/2, introduceSize.width, introduceSize.height);
            [introduce drawInRect:introduceRect];
        }
        
        if (![self.delegate respondsToSelector:@selector(centerViewInCircleChartView:)] && [self.delegate respondsToSelector:@selector(titleInCircleChartView:)]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:[self.delegate titleInCircleChartView:self]];
            [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
            CGSize titleSize = [title size];
            [title drawInRect:CGRectMake(_centerPoint.x - titleSize.width/2, _centerPoint.y, titleSize.width, titleSize.height)];
        }
    }
}

- (void)reloadData {
    [self reloadDataWithAnimate:YES];
    [self setNeedsDisplay];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfCircleInCircleChartView:)], @"You must implemetation the 'numberOfCircleInCircleChartView:' method");
    NSAssert([self.dataSource respondsToSelector:@selector(circleChartView:valueOfCircleAtIndex:)], @"You must implemetation the 'circleChartView:valueOfCircleAtIndex:' method");
    _numberOfCircle = [self.dataSource numberOfCircleInCircleChartView:self];
    _chartDataSource = [[NSMutableDictionary alloc] initWithCapacity:_numberOfCircle];
    for (NSInteger index = 0; index < _numberOfCircle; index ++) {
        id value = [self.dataSource circleChartView:self valueOfCircleAtIndex:index];
        [_chartDataSource setObject:value forKey:@(index)];
    }
    _sortKeys = [_chartDataSource keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 floatValue] < [obj2 floatValue];
    }];
    
    _circleColors = [[NSMutableArray alloc] initWithCapacity:_numberOfCircle];
    
    CGFloat angleValue = _maxAngle/[_chartDataSource[[_sortKeys firstObject]] floatValue];
    CGFloat circleWidth = _maxRadius/(_numberOfCircle + 1);
    for (NSInteger index = 0; index < _numberOfCircle; index ++) {
        NSInteger keyIndex = [_sortKeys[index] integerValue];
        UIColor *circleColor = [UIColor colorWithRed:(index + 1.0)/_numberOfCircle green:1 - (index + 1.0)/_numberOfCircle blue:index * 1.0/_numberOfCircle alpha:1.0];
        if ([self.delegate respondsToSelector:@selector(circleChartView:colorOfCircleAtIndex:)]) {
            circleColor = [self.delegate circleChartView:self colorOfCircleAtIndex:keyIndex];
        }
        [_circleColors addObject:circleColor];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGFloat radius = _maxRadius - circleWidth * index - circleWidth/2;
        CGFloat angle = [_chartDataSource[@(keyIndex)] floatValue] * angleValue;
        [bezierPath addArcWithCenter:_centerPoint radius:radius startAngle:3 * M_PI_2 endAngle:3 * M_PI_2 - angle clockwise:NO];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.strokeColor = circleColor.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = circleWidth - _circlePadding;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        if (animate) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(0.0);
            animation.toValue = @(1.0);
            animation.repeatCount = 1.0;
            animation.duration = angle/3 * M_PI_2 * 0.5;
            animation.fillMode = kCAFillModeForwards;
            [shapeLayer addAnimation:animation forKey:@"animation"];
        }
        
        if ([self.delegate respondsToSelector:@selector(centerViewInCircleChartView:)]) {
            UIView *view = [self.delegate centerViewInCircleChartView:self];
            view.center = CGPointMake(_centerPoint.x, _centerPoint.y + CGRectGetHeight(view.frame));
            [self addSubview:view];
        }
    }
}


@end
