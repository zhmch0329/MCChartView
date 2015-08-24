//
//  MCCoverageLayer.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCCoverageLayer.h"

@implementation MCCoverageLayer

- (instancetype)initWithLayer:(MCCoverageLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.minRadius = layer.minRadius;
        self.maxRadius = layer.maxRadius;
        self.centerPoint = layer.centerPoint;
        self.startAngle = layer.startAngle;
        self.endAngle = layer.endAngle;
        self.coverageColor = layer.coverageColor;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if([key isEqualToString:@"radius"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat lineWidth = _radius - _minRadius;
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextAddArc(ctx, _centerPoint.x, _centerPoint.y, _radius - lineWidth/2, _startAngle, _endAngle, YES);
    CGContextSetStrokeColorWithColor(ctx, _coverageColor);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextStrokePath(ctx);
}

- (void)reloadRadiusWithAnimate:(BOOL)animate {
    [self reloadRadiusWithAnimate:animate duration:1.5];
}

- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration {
    if (animate) {
        _radius = _maxRadius;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"radius"];
        animation.fromValue = @(_minRadius + 10);
        animation.toValue = @(_maxRadius);
        animation.repeatCount = 1;
        animation.duration = duration;
        animation.fillMode = kCAFillModeBoth;
        [self addAnimation:animation forKey:@"angle_key"];
    } else {
        _radius = _maxRadius;
        [self setNeedsDisplay];
    }
}

@end
