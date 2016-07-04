//
//  FYHealthyCircleChart.m
//  Pet
//
//  Created by 邓伟杰 on 16/6/30.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "FYHealthyCircleChart.h"
#import "FYHealthyCircleView.h"

#define CIRCLE_OUT_HEIGHT       100
#define CIRCLE_MINDLE_HEIGHT    80
#define CIRCLE_IN_HEIGHT        60
#define LINE_WIDTH              12

@interface FYHealthyCircleChart()

@property (nonatomic) FYHealthyCircleView * circleChartBasic;
@property (nonatomic) FYHealthyCircleView * circleChartSport;

@end

@implementation FYHealthyCircleChart

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame basicPercent:0 sportPercent:0];
}

- (instancetype)initWithFrame:(CGRect)frame basicPercent:(CGFloat)basic sportPercent:(CGFloat)sport{
    //暂时是固定大小
    frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    if (self = [super initWithFrame:frame]) {
        _basicConsumePercent = basic;
        _sportConsumePercent = sport;
        [self setupDefaultValues:frame];
    }
    
    return self;
}

- (void)setupDefaultValues:(CGRect)frame
{
    self.backgroundColor=[UIColor whiteColor];
    
    [self drawLine];
    
    _circleChartBasic=({
        FYHealthyCircleView *Circhart = [[FYHealthyCircleView alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_MINDLE_HEIGHT, CIRCLE_MINDLE_HEIGHT) percent:_basicConsumePercent lineWidth:6 strokeColor:RGBAHEX(0x2acc89,1) animated:YES gradientColor:nil lineDashPattern:nil];
        Circhart;
    });
    [self addSubview:_circleChartBasic];
    
    
    _circleChartSport=({
        
        FYHealthyCircleView *Circhart=[[FYHealthyCircleView alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_IN_HEIGHT, CIRCLE_IN_HEIGHT) percent:_sportConsumePercent lineWidth:6 strokeColor:RGBAHEX(0x008850,1) animated:YES gradientColor:nil lineDashPattern:nil];
        Circhart;
    });
    [self addSubview:_circleChartSport];
    _circleChartSport.center=CGPointMake(CIRCLE_OUT_HEIGHT/2, CIRCLE_OUT_HEIGHT/2);
    _circleChartBasic.center=_circleChartSport.center;
}


- (void)drawLine{
    CGFloat lineWidth = LINE_WIDTH;
    CGFloat startAngle = -90.0f ;
    CGFloat endAngle = -90.01f ;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                              radius:((CIRCLE_IN_HEIGHT* 0.5) - (lineWidth/3.0f))
                                                          startAngle:DEGREES_TO_RADIANS(startAngle)
                                                            endAngle:DEGREES_TO_RADIANS(endAngle)
                                                           clockwise:YES];
    
    CAShapeLayer *line =  [CAShapeLayer layer];
    line.lineWidth = 0.5f ;
    line.strokeColor = RGBAHEX(0xe9e9e9,1).CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.path = circlePath.CGPath;
    line.lineDashPhase = 2;
    line.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3],nil];
    [self.layer addSublayer:line];
    
    
    UIBezierPath *circlePathPlay = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:((CIRCLE_MINDLE_HEIGHT * 0.5) - (lineWidth/3.0f))
                                                              startAngle:DEGREES_TO_RADIANS(startAngle)
                                                                endAngle:DEGREES_TO_RADIANS(endAngle)
                                                               clockwise:YES];
    
    CAShapeLayer *linePlay =  [CAShapeLayer layer];
    linePlay.lineWidth = 0.5f ;
    linePlay.strokeColor = RGBAHEX(0xe9e9e9,1).CGColor;
    linePlay.fillColor = [UIColor clearColor].CGColor;
    linePlay.path = circlePathPlay.CGPath;
    linePlay.lineDashPhase = 2;
    linePlay.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3],nil];
    [self.layer addSublayer:linePlay];

    CAShapeLayer *line2;
    UIBezierPath *circlePath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                               radius:((CIRCLE_OUT_HEIGHT * 0.5) - (lineWidth/2.0f))
                                                           startAngle:DEGREES_TO_RADIANS(startAngle)
                                                             endAngle:DEGREES_TO_RADIANS(endAngle)
                                                            clockwise:YES];
    
    line2 =  [CAShapeLayer layer];
    line2.lineWidth = 0.5f ;
    line2.strokeColor = RGBAHEX(0xe9e9e9,1).CGColor;
    line2.fillColor = [UIColor clearColor].CGColor;
    line2.path = circlePath2.CGPath;
    line2.lineDashPhase=2;
    line2.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3],nil];
    [self.layer addSublayer:line2];
    
}

- (void)startStroke{
    [_circleChartBasic startStroke];
    [_circleChartSport startStroke];
}

#pragma mark - setter
- (void)setBasicConsumePercent:(CGFloat)basicConsumePercent{
    _basicConsumePercent = basicConsumePercent;
    [_circleChartBasic growChartToPercent:_basicConsumePercent];
}

- (void)setSportConsumePercent:(CGFloat)sportConsumePercent{
    _sportConsumePercent = sportConsumePercent;
    [_circleChartSport updateChartByPercent:_sportConsumePercent];
}

@end
