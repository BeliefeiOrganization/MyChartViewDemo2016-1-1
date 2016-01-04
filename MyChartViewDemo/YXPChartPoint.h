//
//  YXPChartPoint.h
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
//typedef NS_ENUM(NSInteger, ChartPointStyle) {
//    
//    ChartPointStyle_Default = 1<<0,
//    ChartPointStyle_Square = 1<<1,
//    ChartPointStyle_Circle = ChartPointStyle_Default,
//    ChartPointStyle_Custom
//};

@interface YXPChartPoint : NSObject

@property (nonatomic, copy) NSString *tipString;

@property (nonatomic, assign) CGFloat tipFontSize;

@property (nonatomic, assign) NSNumber *yValue;


@property (nonatomic, strong) UIColor *pointFillColor;

@property (nonatomic, strong) UIColor *pointStrokeColor;

@property (nonatomic, assign) CGFloat strokeWidth;

//@property (nonatomic, assign) ChartPointStyle pointStyle;

//这两个值使计算这个点在表中的坐标位置 不需要外界设置
@property (nonatomic, assign) CGFloat yPoint;

@property (nonatomic, assign) CGFloat xPoint;

@property (nonatomic, assign) BOOL isSpecialPoint;
@end
