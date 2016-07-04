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

@property (nonatomic) FYHealthyCircleView * circleChartBasis;
@property (nonatomic) FYHealthyCircleView * circleChartPlay;

@property (nonatomic) CAShapeLayer *line;
@property (nonatomic) CAShapeLayer *linePlay;

@end

@implementation FYHealthyCircleChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues:frame];
        
    }
    
    return self;
}

- (void)setupDefaultValues:(CGRect)frame
{
    self.backgroundColor=[UIColor whiteColor];
    
    [self drawLine];
    
    _circleChartBasis=({
        
        FYHealthyCircleView *Circhart = [[FYHealthyCircleView alloc]initWithFrame:CGRectMake(0,150.0, CIRCLE_IN_HEIGHT, CIRCLE_IN_HEIGHT)
                                                                    total:@100
                                                                  current:@0
                                                                clockwise:YES];
        Circhart.lineWidth = @6;
        Circhart.backgroundColor = [UIColor clearColor];
        [Circhart setStrokeColor:RGBAHEX(0x008850,1)];
        [Circhart setStrokeColorGradientStart:[UIColor clearColor]];
        [Circhart strokeChart];
        Circhart;
        
    });
    [self addSubview:_circleChartBasis];
    
    
    _circleChartPlay=({
        
        FYHealthyCircleView *Circhart=[[FYHealthyCircleView alloc]initWithFrame:CGRectMake(0,150.0, CIRCLE_MINDLE_HEIGHT, CIRCLE_MINDLE_HEIGHT)
                                                                    total:@100
                                                                  current:@0
                                                                clockwise:YES];
        Circhart.lineWidth = @6;
        Circhart.backgroundColor = [UIColor clearColor];
        [Circhart setStrokeColor:RGBAHEX(0x2acc89,1)];
        [Circhart setStrokeColorGradientStart:[UIColor clearColor]];
        [Circhart strokeChart];
        Circhart;
        
    });
    [self addSubview:_circleChartPlay];
    _circleChartPlay.center=CGPointMake(CIRCLE_OUT_HEIGHT/2, CIRCLE_OUT_HEIGHT/2);
    _circleChartBasis.center=_circleChartPlay.center;
}


-(void)drawLine
{
    
    CGFloat lineWidth = LINE_WIDTH;
    CGFloat startAngle = -90.0f ;
    CGFloat endAngle = -90.01f ;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                              radius:((CIRCLE_IN_HEIGHT* 0.5) - (lineWidth/3.0f))
                                                          startAngle:DEGREES_TO_RADIANS(startAngle)
                                                            endAngle:DEGREES_TO_RADIANS(endAngle)
                                                           clockwise:YES];
    
    _line =  [CAShapeLayer layer];
    _line.lineWidth = 0.5f ;
    _line.strokeColor = RGBAHEX(0xe9e9e9,1).CGColor;
    _line.fillColor = [UIColor clearColor].CGColor;
    _line.path = circlePath.CGPath;
    _line.lineDashPhase = 2;
    _line.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3],nil];
    [self.layer addSublayer:_line];
    
    
    UIBezierPath *circlePathPlay = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:((CIRCLE_MINDLE_HEIGHT * 0.5) - (lineWidth/3.0f))
                                                              startAngle:DEGREES_TO_RADIANS(startAngle)
                                                                endAngle:DEGREES_TO_RADIANS(endAngle)
                                                               clockwise:YES];
    
    _linePlay =  [CAShapeLayer layer];
    _linePlay.lineWidth = 0.5f ;
    _linePlay.strokeColor = RGBAHEX(0xe9e9e9,1).CGColor;
    _linePlay.fillColor = [UIColor clearColor].CGColor;
    _linePlay.path = circlePathPlay.CGPath;
    _linePlay.lineDashPhase = 2;
    _linePlay.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3],nil];
    [self.layer addSublayer:_linePlay];
    
    
    
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

-(void)updateBasisValue:(CGFloat)basisValue circleChartPlay:(CGFloat)playValue
{
    [_circleChartPlay updateChartByCurrent:@(playValue)];
    [_circleChartBasis updateChartByCurrent:@(basisValue)];
}

@end
