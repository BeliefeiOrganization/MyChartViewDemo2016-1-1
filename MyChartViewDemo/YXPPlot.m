//
//  YXPPlot.m
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import "YXPPlot.h"

@implementation YXPPlot

- (instancetype)init{
    if ((self = [super init])) {
        [self makeSomeDefaultSet];
    }
    
    return self;
}
- (void)makeSomeDefaultSet{
//    @property (nonatomic ,strong) UIColor *plotFillColor;
//    @property (nonatomic, assign) CGFloat  plotStrokeWidth;
//    @property (nonatomic, strong) UIColor *plotStrokeColor;
    self.plotFillColor = [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5];
    self.plotStrokeColor = [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1];
    self.plotStrokeWidth = 2;
}
@end
