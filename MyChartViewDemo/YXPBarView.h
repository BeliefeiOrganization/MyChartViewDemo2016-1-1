//
//  YXPBarView.h
//  MyChartViewDemo
//
//  Created by 段龙飞 on 16/1/4.
//  Copyright © 2016年 段龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXPBarView : UIView

@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@end
