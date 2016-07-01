//
//  ViewController.m
//  CASharpLayer
//
//  Created by 邓伟杰 on 16/7/1.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "FYHealthyCircleChart.h"


@interface ViewController ()
@property (nonatomic,strong) FYHealthyCircleChart *chart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FYHealthyCircleChart *chart = [[FYHealthyCircleChart alloc]initWithFrame:CGRectMake(20, 100, 100, 100)];
    [self.view addSubview:chart];
    _chart = chart;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_chart updateBasisValue:10 circleChartPlay:15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
