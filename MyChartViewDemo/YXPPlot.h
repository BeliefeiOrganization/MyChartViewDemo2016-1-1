//
//  YXPPlot.h
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXPChartPoint.h"

@interface YXPPlot : NSObject

@property (nonatomic ,strong) UIColor *plotFillColor;
@property (nonatomic, assign) CGFloat  plotStrokeWidth;
@property (nonatomic, strong) UIColor *plotStrokeColor;
@property (nonatomic, strong) NSArray *plotValues; //一组chartPoint



@end
