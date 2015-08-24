//
//  MCChartInformationView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/18.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCChartInformationView.h"

CGFloat static const kMCChartInformationViewCornerRadius = 5.0;
CGFloat const kMCTextDefaultWidth = 40.0f;
CGFloat const kMCTextDefaultHeight = 20.0f;
CGFloat const kMCTipDefaultWidth = 8.0f;
CGFloat const kMCTipDefaultHeight = 5.0f;

#define kMCChartInformationViewColor [UIColor colorWithWhite:1.0 alpha:0.9]

@interface MCChartInformationView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MCChartInformationView

- (instancetype)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectMake(0, 0, kMCTextDefaultWidth, kMCTextDefaultHeight + kMCTipDefaultHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kMCChartInformationViewCornerRadius;
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.layer.cornerRadius = kMCChartInformationViewCornerRadius;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:12.0];
        _textLabel.backgroundColor = kMCChartInformationViewColor;
        _textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(0, 0, kMCTextDefaultWidth, kMCTextDefaultHeight);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSaveGState(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) - kMCTipDefaultWidth/2, kMCTextDefaultHeight);
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) + kMCTipDefaultWidth/2, kMCTextDefaultHeight);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, kMCChartInformationViewColor.CGColor);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

@end
