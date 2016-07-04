//
//  FYHealthyCircleChart.h
//  Pet
//
//  Created by 邓伟杰 on 16/6/30.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYHealthyCircleView;
@interface FYHealthyCircleChart : UIView

@property (nonatomic,assign) CGFloat basicConsumePercent;
@property (nonatomic,assign) CGFloat sportConsumePercent;

- (instancetype)initWithFrame:(CGRect)frame basicPercent:(CGFloat)basic sportPercent:(CGFloat)sport;
//开始动画
- (void)startStroke;

@end
