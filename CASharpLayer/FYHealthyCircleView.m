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
@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) CAShapeLayer *gradientMask;

@end

@implementation FYHealthyCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame percent:0];
}

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent{
    return [self initWithFrame:frame percent:percent lineWidth:LINE_WIDTH_DEFAULT strokeColor:COLOR_DEFAULT];
}

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor{
    return [self initWithFrame:frame percent:percent lineWidth:lineWidth strokeColor:strokeColor animated:NO gradientColor:nil lineDashPattern:nil];
}

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor animated:(BOOL)animated gradientColor:(UIColor *)gradientColor lineDashPattern:(NSArray<NSNumber *> *)lineDashPattern{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _percent = percent;
        _lineWidth = lineWidth ?: LINE_WIDTH_DEFAULT;
        _strokeColor = strokeColor ?: COLOR_DEFAULT;
        _animated = animated;
        _gradientColor = gradientColor;
        _lineDashPattern = lineDashPattern;
        
        _duration = 1.0f;
        _clockwise = YES;
        
        _circle               = [CAShapeLayer layer];
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.strokeColor   = _strokeColor.CGColor;
        _circle.lineWidth     = _lineWidth;
        _circle.zPosition     = 1;
        _circle.strokeStart   = 0;
        _circle.strokeEnd     = !_animated ? _percent : 0;
        _circle.lineDashPattern = _lineDashPattern;
        
        if (_gradientColor) {
            
            _gradientMask = [CAShapeLayer layer];
            _gradientMask.fillColor = [UIColor clearColor].CGColor;
            _gradientMask.strokeColor = [UIColor blackColor].CGColor;
            _gradientMask.lineWidth = _lineWidth;
            _gradientMask.lineCap = kCALineCapRound;
            _gradientMask.strokeStart = 0;
            _gradientMask.strokeEnd = !_animated ? _percent : 0.001;
            _gradientMask.lineDashPattern = _lineDashPattern;
            
            
            _gradientLayer = [CAGradientLayer layer];
            _gradientLayer.startPoint = CGPointMake(0.5, 1);
            _gradientLayer.endPoint = CGPointMake(0.5, 0);
            _gradientLayer.colors = @[(__bridge id)_strokeColor.CGColor,(__bridge id)_gradientColor.CGColor];
            _gradientLayer.zPosition = 2;
            
            [_gradientLayer setMask:_gradientMask];
            [self.layer addSublayer:_gradientLayer];
        }
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
    if (_gradientColor) {
        _gradientMask.path = _circle.path;
        _gradientMask.frame = self.layer.bounds;
        _gradientLayer.frame = self.layer.bounds;
    }
}

#pragma mark - setter
- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern{
    _lineDashPattern = lineDashPattern;
    _circle.lineDashPattern = _lineDashPattern;
    if (_gradientColor) {
        _gradientMask.lineDashPattern = _lineDashPattern;
    }
}


#pragma mark -
- (void)startStroke{
    if (!_animated) return;
    
    //Add Animation
    
    CABasicAnimation *animation = [self createBasicAnimationWithFromValue:@0.0 toValue:@(_percent)];
    [_circle addAnimation:animation forKey:@"strokeEndAnimation"];
    
    if (_gradientColor) {
        [_gradientMask addAnimation:animation forKey:@"strokeEndAnimation"];
        _gradientMask.strokeEnd = _percent;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _circle.strokeEnd = _percent;
    [_circle removeAllAnimations];
}

//更新百分比
- (void)updateChartByPercent:(CGFloat)percent{
    _percent = percent;
    if (_animated) {
        CABasicAnimation *anim = [self createBasicAnimationWithFromValue:@0 toValue:@(percent)];
        [_circle addAnimation:anim forKey:@"strokeEndUpdateANimation"];
    }else{
        _circle.strokeEnd = _percent;
    }
}

//在当前百分比变化到指定值（开启动画才有效）
- (void)growChartToPercent:(CGFloat)percent{
    if (!_animated) return;
    CABasicAnimation *anim = [self createBasicAnimationWithFromValue:@(_percent) toValue:@(percent)];
    [_circle addAnimation:anim forKey:@"strokeEndGrowAnimation"];
    _percent = percent;
}

- (CABasicAnimation *)createBasicAnimationWithFromValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}
@end
