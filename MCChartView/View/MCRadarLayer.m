//
//  MCRadarLayer.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCRadarLayer.h"

@implementation MCRadarLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _radarFillColor = [UIColor clearColor].CGColor;
        _pointRadius = 3.0;
        _progress = 1.0;
    }
    return self;
}

- (instancetype)initWithLayer:(MCRadarLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        _radarFillColor = layer.radarFillColor;
        _pointRadius = layer.pointRadius;
        _lineWidth = layer.lineWidth;
        _fillColor = layer.fillColor;
        _strokeColor = layer.strokeColor;
        _radius = layer.radius;
        _centerPoint = layer.centerPoint;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetFillColorWithColor(ctx, _fillColor);
    CGContextSetStrokeColorWithColor(ctx, _strokeColor);
    
    CGFloat layerRadius = [[_radius firstObject] floatValue] * _progress;
    CGPoint point = [self pointAtIndex:0 radius:layerRadius];
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (NSInteger index = 1; index < _radius.count; index ++) {
        CGFloat layerRadius = [_radius[index] floatValue] * _progress;
        CGPoint point = [self pointAtIndex:index radius:layerRadius];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    if (_pointRadius > 0) {
        CGContextSetLineWidth(ctx, _lineWidth);
        CGContextSetFillColorWithColor(ctx, _radarFillColor);
        CGContextSetStrokeColorWithColor(ctx, _strokeColor);
        for (NSInteger index = 0; index < _radius.count; index ++) {
            CGFloat layerRadius = [_radius[index] floatValue] * _progress;
            CGPoint point = [self pointAtIndex:index radius:layerRadius];
            CGContextMoveToPoint(ctx, point.x + _pointRadius, point.y);
            CGContextAddArc(ctx, point.x, point.y, _pointRadius, 0, 2 * M_PI, NO);
        }
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
}

- (CGPoint)pointAtIndex:(NSInteger)index radius:(CGFloat)radius {
    CGFloat angleOfValue = 2 * M_PI/_radius.count;
    return CGPointMake(_centerPoint.x + radius * sin(index * angleOfValue), _centerPoint.y - radius * cos(index * angleOfValue));
}

- (void)reloadRadiusWithAnimate:(BOOL)animate {
    [self reloadRadiusWithAnimate:animate duration:0.75];
}

- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration {
    if (animate) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        animation.repeatCount = 1.0;
        animation.duration = duration;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [self addAnimation:animation forKey:@"animation"];
    } else {
        [self setNeedsDisplay];
    }
}

@end
