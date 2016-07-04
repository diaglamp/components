//
//  FYHealthyCircleView.m
//  Pet
//
//  Created by 邓伟杰 on 16/6/30.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "FYHealthyCircleView.h"

#define LINE_WIDTH_DEFAULT 12.0
#define COLOR_DEFAULT [UIColor greenColor]

@interface FYHealthyCircleView()

@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *gradientMask;

@end

@implementation FYHealthyCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame percent:0];
}

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent{
    return [self initWithFrame:frame percent:percent lineWidth:LINE_WIDTH_DEFAULT strokeColor:COLOR_DEFAULT animated:NO];
}

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor animated:(BOOL)animated{
    if (self = [super initWithFrame:frame]) {
        _percent = percent;
        _lineWidth = lineWidth;
        _strokeColor = strokeColor;
        _animated = animated;
        _duration = 1.0f;
        _clockwise = YES;
        _chartType = FYChartFormatTypeArc;
        
        
        
        
        
        _circle               = [CAShapeLayer layer];
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.strokeColor   = strokeColor.CGColor;
        _circle.lineWidth     = _lineWidth;
        _circle.zPosition     = 1;
        
        [self.layer addSublayer:_circle];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat startAngle = _clockwise ? -90.0f : 270.0f;
    CGFloat endAngle = _clockwise ? -90.01f : 270.01f;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                              radius:(self.frame.size.width * 0.5) - (_lineWidth/2.0f)
                                                          startAngle:DEGREES_TO_RADIANS(startAngle)
                                                            endAngle:DEGREES_TO_RADIANS(endAngle)
                                                           clockwise:_clockwise];
    _circle.path          = circlePath.CGPath;
    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
}

- (void)strokeChart
{
    // Add circle params
    
    _circle.lineWidth   = _lineWidth;
    _circle.strokeColor = _strokeColor.CGColor;
//    _circleBackground.lineWidth = _lineWidth;
//    _circleBackground.strokeEnd = 1.0;
    
    // Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @(_percent);
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = _percent;
    
    // Check if user wants to add a gradient from the start color to the bar color
    if (_strokeColorGradientStart) {
        
        // Add gradient
        self.gradientMask = [CAShapeLayer layer];
        self.gradientMask.fillColor = [[UIColor clearColor] CGColor];
        self.gradientMask.strokeColor = [[UIColor blackColor] CGColor];
        self.gradientMask.lineWidth = _circle.lineWidth;
        self.gradientMask.lineCap = kCALineCapRound;
        CGRect gradientFrame = CGRectMake(0, 0, 2*self.bounds.size.width, 2*self.bounds.size.height);
        self.gradientMask.frame = gradientFrame;
        self.gradientMask.path = _circle.path;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5,1.0);
        gradientLayer.endPoint = CGPointMake(0.5,0.0);
        gradientLayer.frame = gradientFrame;
        UIColor *endColor = (_strokeColor ? _strokeColor : [UIColor greenColor]);
        NSArray *colors = @[
                            (id)endColor.CGColor,
                            (id)_strokeColorGradientStart.CGColor
                            ];
        gradientLayer.colors = colors;
        
        [gradientLayer setMask:self.gradientMask];
        
        [_circle addSublayer:gradientLayer];
        
        self.gradientMask.strokeEnd = _percent;
        
        [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
}

//更新百分比
- (void)updateChartByPercent:(CGFloat)percent{
    
}

//在当前百分比变化到指定值（开启动画才有效）
- (void)growChartToPercent:(CGFloat)percent{
    
}
@end
