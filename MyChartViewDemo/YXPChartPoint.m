//
//  YXPChartPoint.m
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import "YXPChartPoint.h"

@implementation YXPChartPoint

- (instancetype)init{
    if((self = [super init])){
        [self makeSomeDefault];
    }
    
    return self;
}

- (void)makeSomeDefault{
    
    /**
     @property (nonatomic, copy) NSString *tipString;
     
     @property (nonatomic, strong) UIFont *tipFont;
     
     @property (nonatomic, assign) NSNumber *yValue;
     
     @property (nonatomic, assign) CGFloat yPoint;
     
     @property (nonatomic, assign) CGFloat xPoint;
     
     @property (nonatomic, strong) UIColor *pointFillColor;
     
     @property (nonatomic, strong) UIColor *pointStrokeColor;
     
     @property (nonatomic, assign) CGFloat strokeWidth;
     */
    
    self.tipString = @"";
    self.yPoint = 0;
    self.xPoint = 0;
    self.yValue = @0;
    self.pointFillColor = [UIColor purpleColor];
    self.strokeWidth = 1;
    self.pointStrokeColor = [UIColor greenColor];
    self.tipFontSize = 13;
    
}

@end
