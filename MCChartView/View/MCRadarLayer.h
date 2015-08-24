//
//  MCRadarLayer.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCRadarLayer : CALayer

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) NSArray *radius;

@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGColorRef radarFillColor;
@property (nonatomic, assign) CGFloat pointRadius;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGColorRef fillColor;
@property (nonatomic, assign) CGColorRef strokeColor;

@property (nonatomic, assign) CGFloat progress;

- (void)reloadRadiusWithAnimate:(BOOL)animate;
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
