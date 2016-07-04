//
//  ViewController.m
//  CASharpLayer
//
//  Created by 邓伟杰 on 16/7/1.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "FYHealthyCircleChart.h"
#import "FYHealthyCircleView.h"


@interface ViewController ()
@property (nonatomic,strong) FYHealthyCircleChart *chart;
@property (nonatomic,strong) FYHealthyCircleView *circle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FYHealthyCircleView *circle = [[FYHealthyCircleView alloc]initWithFrame:CGRectZero percent:0.7];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    _circle.animated = YES;
    _circle = circle;
    
    [self.view addSubview:circle];
    
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(circle);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[circle(==100)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[circle(==100)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:viewsDict]];
    
    _chart = ({
        FYHealthyCircleChart *chart = [[FYHealthyCircleChart alloc]initWithFrame:CGRectMake(100, 300, 0, 0) basicPercent:0.3 sportPercent:0.7];
        chart;
    });
    [self.view addSubview:_chart];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_chart startStroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_circle startStroke];
    _chart.basicConsumePercent = 0.9;
    _chart.sportConsumePercent = 0.9;
}

@end
