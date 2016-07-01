//
//  FYHealthyCircleView.m
//  Pet
//
//  Created by 邓伟杰 on 16/6/30.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "FYHealthyCircleView.h"

#define LINE_WIDTH_DEFAULT 12.0
#define COLOR_DEFAULT [UIColor greenColor]

@interface FYHealthyCircleView()

@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *gradientMask;
@property (nonatomic) CAShapeLayer *circleBackground;

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
        
        CGFloat startAngle = _clockwise ? -90.0f : 270.0f;
        CGFloat endAngle = _clockwise ? -90.01f : 270.01f;
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f)
                                                                  radius:(frame.size.width * 0.5) - (_lineWidth/2.0f)
                                                              startAngle:DEGREES_TO_RADIANS(startAngle)
                                                                endAngle:DEGREES_TO_RADIANS(endAngle)
                                                               clockwise:_clockwise];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.strokeColor   = strokeColor.CGColor;
        _circle.lineWidth     = _lineWidth;
        _circle.zPosition     = 1;
        
        
        _circleBackground             = [CAShapeLayer layer];
        _circleBackground.path        = circlePath.CGPath;
        _circleBackground.lineCap     = kCALineCapRound;
        _circleBackground.fillColor   = [UIColor clearColor].CGColor;
        _circleBackground.lineWidth   = _lineWidth;
        _circleBackground.strokeColor = [UIColor clearColor].CGColor;
        _circleBackground.strokeEnd   = 1.0;
        _circleBackground.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBackground];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)strokeChart
{
    // Add circle params
    
    _circle.lineWidth   = _lineWidth;
    _circleBackground.lineWidth = _lineWidth;
    _circleBackground.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;
    
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

- (void)growChartByAmount:(NSNumber *)growAmount
{
    NSNumber *updatedValue = [NSNumber numberWithFloat:[_current floatValue] + [growAmount floatValue]];
    
    // Add animation
    [self updateChartByCurrent:updatedValue];
}


-(void)updateChartByCurrent:(NSNumber *)current{
    if(current && ([current floatValue] > 0)){
        [self updateChartByCurrent:current
                           byTotal:_total];
    }else{
        [self updateChartByCurrent:@(0)
                           byTotal:_total];
    }
}

-(void)updateChartByCurrent:(NSNumber *)current byTotal:(NSNumber *)total {
    // Add animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @([_current floatValue] / [_total floatValue]);
    pathAnimation.toValue = @([current floatValue] / [total floatValue]);
    _circle.strokeEnd   = [current floatValue] / [total floatValue];
    
    if (_strokeColorGradientStart) {
        self.gradientMask.strokeEnd = _circle.strokeEnd;
        [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _current = current;
    _total = total;
}

//更新百分比
- (void)updateChartByPercent:(CGFloat)percent;

//在当前百分比变化到指定值（开启动画才有效）
- (void)growChartToPercent:(CGFloat)percent;
@end
