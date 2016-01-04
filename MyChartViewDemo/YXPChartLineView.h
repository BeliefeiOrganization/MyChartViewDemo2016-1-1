//
//  YXPChartLineView.h
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPPlot.h"

@class YXPChartLineView;

@interface YXPChartLineView : UIView


#pragma mark -- 需要设置默认值
//UIKIT_EXTERN NSString *const kXAxisMsgColorKey;
//UIKIT_EXTERN NSString *const kXAxisMsgFontKey;
//UIKIT_EXTERN NSString *const kYAxisMsgColorKey;
//UIKIT_EXTERN NSString *const kYAxisMsgFontKey;
//UIKIT_EXTERN NSString *const kPlotBackgroundLineColorKye;
//
//@property (nonatomic, assign) NSDictionary *chartLineThemeAttribute;  //使用以上属性定制

@property (nonatomic, assign) UIEdgeInsets chartEdgeInsets;

#pragma mark - 下参数需要在初始化后指定
@property (nonatomic, assign) NSInteger numberOfScaleXAxis;

@property (nonatomic, assign) NSInteger numberOfScaleYAxis; //

@property (nonatomic, strong, readonly) NSMutableArray *plots; //必须保证plots中数据源的数量等于numberOfScaleXAxis

@property (nonatomic, assign) CGSize chartSize;

@property (nonatomic, copy) void(^xAxisScaleMsgBlock)(NSInteger indexXAxis,YXPPlot *plot);

@property (nonatomic, copy) void(^yAxisScaleMsgBlock)(NSInteger indexYAxis,YXPChartLineView *chartLineView);

@property (nonatomic, copy) void(^pointShowMsgBlock)(NSInteger pointIndexOfPlot,NSInteger plotIndex,YXPPlot *plot);


@property (nonatomic, copy) void(^clickPointBlock)(NSInteger pointIndex, YXPPlot *plot,YXPChartLineView *chartLineView);


- (void)addANewPlot:(YXPPlot *)plot;

- (void)startDrawChartLineViewWithAnimation:(BOOL)animation;

- (void)updateChartLine;

@end
