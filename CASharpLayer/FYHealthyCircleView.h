//
//  FYHealthyCircleView.h
//  Pet
//
//  Created by 邓伟杰 on 16/6/30.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAHEX(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

typedef NS_ENUM (NSUInteger, FYChartFormatType) {
    FYChartFormatTypeArc, //弧线
    FYChartFormatTypeSector //扇形
};

//百分比图
@interface FYHealthyCircleView : UIView

//弧线占圆百分比,只能初始化或者通过方法修改
@property (nonatomic,readonly,assign) CGFloat percent;

//线宽,默认
@property (nonatomic,assign) CGFloat lineWidth;
//线条颜色，默认绿色
@property (nonatomic,strong) UIColor *strokeColor;
//渐变颜色,默认为nil
@property (nonatomic,strong) UIColor *strokeColorGradientStart;
//是否播放动画，default YES
@property (nonatomic,assign,getter=isAnimated) BOOL animated;
//动画播放时间，默认1s （TODO ：提供 播放时间 = 系数 * percent 的接口）
@property (nonatomic,assign) NSTimeInterval duration;
//是否顺时针，默认顺时针
@property (nonatomic,assign,getter=isClockwise) BOOL clockwise;


//以下属性未完成 
//图标类型，默认是线 其他功能未完成
@property (nonatomic,assign) FYChartFormatType chartType;
//是否文字显示百分比,defalut is NO
@property (nonatomic,assign) BOOL displayCountingLabel;

//shadow属性 后续添加


- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent;

- (instancetype)initWithFrame:(CGRect)frame percent:(CGFloat)percent lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor animated:(BOOL)animated;

//开始画图
- (void)strokeChart;

//更新百分比
- (void)updateChartByPercent:(CGFloat)percent;

//开始动画


//在当前百分比变化到指定值（开启动画才有效）
- (void)growChartToPercent:(CGFloat)percent;
@end
