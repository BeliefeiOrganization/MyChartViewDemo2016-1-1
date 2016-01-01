//
//  YXPChartLineView.m
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import "YXPChartLineView.h"


@implementation YXPChartLineView
{
    NSNumber *_yMaxValue;
}

- (instancetype)init{
    if ((self = [super init])) {
        [self makeSomeDefaultAttribute];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if ((self = [super initWithFrame:frame])) {
        [self makeSomeDefaultAttribute];
 
    }
    
    return self;
}

- (void)awakeFromNib{
    [self makeSomeDefaultAttribute];
}

- (void)makeSomeDefaultAttribute{
    self.numberOfScaleXAxis = 10;
    self.chartEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _yMaxValue = @0;
}

- (void)setChartEdgeInsets:(UIEdgeInsets)chartEdgeInsets{
    
    _chartEdgeInsets = UIEdgeInsetsMake(chartEdgeInsets.top>0?chartEdgeInsets.top:0, chartEdgeInsets.left>0?chartEdgeInsets.left:0, chartEdgeInsets.bottom>0?chartEdgeInsets.bottom:0, chartEdgeInsets.right>0?chartEdgeInsets.right:0);
}
- (void)startDrawChartLineViewWithAnimation:(BOOL)animation{
    [self caculateMaxValue];
    [self caculateEveryPointXY];
    [self startDrawXYAxisAndScale];
    [self startDrawPlotLine];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)startDrawXYAxisAndScale{
    
    [self drawXYAxis];
    [self drawXYScale];
    
}


- (CGFloat)getChartViewXAxisLength{
    
    return (_chartSize.width - _chartEdgeInsets.left - _chartEdgeInsets.right>0)?_chartSize.width - _chartEdgeInsets.left - _chartEdgeInsets.right:0;
}

- (CGFloat)getChartViewYAxisLength{
    
    return (_chartSize.height - _chartEdgeInsets.top - _chartEdgeInsets.bottom>0)?_chartSize.height - _chartEdgeInsets.top - _chartEdgeInsets.bottom:0;
}

- (void)drawXYScale{
    
    CAShapeLayer *axisLayer = [CAShapeLayer layer];
    
    axisLayer.frame = CGRectMake(0, 0, _chartSize.width, _chartSize.height);
    
    axisLayer.fillColor = [UIColor clearColor].CGColor;
    
    axisLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    
    axisLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    axisLayer.lineWidth = 0.2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    //x轴刻度
    if (_numberOfScaleXAxis>0&&_chartSize.width>0) {
        CGFloat xScale = [self getChartViewXAxisLength]/(_numberOfScaleXAxis + 1);
        
        for (NSInteger i = 1; i <= _numberOfScaleXAxis+1; i++) {
            CGPoint currentPoint = CGPointMake(xScale * i + _chartEdgeInsets.left, _chartEdgeInsets.top);
            
            CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
            
            CGPathAddLineToPoint(path, NULL, currentPoint.x, _chartSize.height-_chartEdgeInsets.bottom);
            
        }

    }
    
    //y轴刻度线
    if (_numberOfScaleYAxis>0&&_chartSize.height>0) {
        CGFloat ySacle = [self getChartViewYAxisLength]/(_numberOfScaleYAxis+1);
        for (NSInteger i = 1; i <= _numberOfScaleYAxis+1; i++) {
            CGPoint currentPoint = CGPointMake( _chartEdgeInsets.left, _chartSize.height-ySacle*i-_chartEdgeInsets.bottom);
            
            CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
            
            CGPathAddLineToPoint(path, NULL, _chartSize.width -_chartEdgeInsets.right, currentPoint.y);
            
        }
    }

    
    
    axisLayer.path = path;
    
    [self.layer addSublayer:axisLayer];
}

- (void)drawXYAxis{
    
    CAShapeLayer *axisLayer = [CAShapeLayer layer];
    
    axisLayer.frame = CGRectMake(0, 0, _chartSize.width, _chartSize.height);

    axisLayer.fillColor = [UIColor clearColor].CGColor;
    
    axisLayer.backgroundColor = [UIColor clearColor].CGColor;
   
    
    axisLayer.strokeColor = [UIColor grayColor].CGColor;
    
    axisLayer.lineWidth = 0.5;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //x轴
    CGPathMoveToPoint(path, NULL,_chartEdgeInsets.left,self.chartSize.height - _chartEdgeInsets.bottom);
    CGPathAddLineToPoint(path, NULL, self.chartSize.width-_chartEdgeInsets.right,  self.chartSize.height - _chartEdgeInsets.bottom);
    //y轴
    CGPathMoveToPoint(path, NULL, _chartEdgeInsets.left, _chartEdgeInsets.top);
    CGPathAddLineToPoint(path, NULL, _chartEdgeInsets.left, self.chartSize.height-_chartEdgeInsets.bottom);

    axisLayer.path = path;
    
    [self.layer addSublayer:axisLayer];
}

- (void)startDrawPlotLine{

     if ([self testEveryPlotPointsCountIsEqualXAxisScale]) {
         for (id plot in _plots) {
             [self drawPlotWithPlot:plot];
         }
         
         //画渐变
         [self drawGradualColor:_plots[0]];

         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             self.layer.sublayers[1].hidden = NO;
         });
     }
    
   
}

- (void)addANewPlot:(YXPPlot *)plot{
    if (plot) {
        if (!_plots) {
            _plots = [NSMutableArray array];
        }
        [_plots addObject:plot];
      
        
    }
}

//- (void)caculateNumberOfXScale{
//    self.numberOfScaleXAxis = self.numberOfScaleXAxis<
//}

- (void)caculateEveryPointXY{
    CGFloat YScale = (_chartSize.height - _chartEdgeInsets.bottom - _chartEdgeInsets.top-10);
    CGFloat XScale = (_chartSize.width - _chartEdgeInsets.left - _chartEdgeInsets.right )/(_numberOfScaleXAxis + 1);
    for (YXPPlot *plot in _plots) {
        for (NSInteger i = 0; i < _numberOfScaleXAxis; i++) {
            YXPChartPoint *point = plot.plotValues[i];
            point.yPoint = _chartSize.height-_chartEdgeInsets.bottom - YScale*([point.yValue floatValue]/[_yMaxValue floatValue]);
            point.xPoint = _chartEdgeInsets.left + (i+1) * XScale;
            NSLog(@"------x=%f---y=%f",point.xPoint,point.yPoint);
            
        }
    }
}

- (void)caculateMaxValue{
    for (YXPPlot *plot in _plots) {
        for (YXPChartPoint *point in plot.plotValues) {
            if (point.yValue>_yMaxValue) {
                _yMaxValue = point.yValue;
            }
        }
    }

}

- (BOOL)testEveryPlotPointsCountIsEqualXAxisScale{
    BOOL isEqual = YES;
    
    for (YXPPlot *plot in _plots) {
        if (plot.plotValues.count<_numberOfScaleXAxis) {
            isEqual = NO;
            break;
        }
    }
    
    return isEqual;
}

- (void)drawPlotWithPlot:(YXPPlot *)plot{
    //划线
    [self drawPlotLine:plot];
    //画圆
    [self drawCircle:plot];
    
    //弹出提示
//    [self drawShowMsg:plot];
    
    
}

- (void)drawPlotLine:(YXPPlot *)plot{
   
        CAShapeLayer *graphLayer = [CAShapeLayer layer];
        graphLayer.frame =self.bounds;
        graphLayer.fillColor = [UIColor clearColor].CGColor;
        graphLayer.backgroundColor = [UIColor clearColor].CGColor;
        [graphLayer setStrokeColor:plot.plotStrokeColor.CGColor];
        [graphLayer setLineWidth:plot.plotStrokeWidth];
        
        CGMutablePathRef graphPath = CGPathCreateMutable();
        YXPChartPoint *beginPoint = plot.plotValues[0];
        CGPathMoveToPoint(graphPath, NULL, _chartEdgeInsets.left, beginPoint.yPoint);
        
        for (YXPChartPoint *point in plot.plotValues) {
            CGPathAddLineToPoint(graphPath, NULL, point.xPoint, point.yPoint);
        }
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 3;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        [graphLayer addAnimation:animation forKey:@"strokeEnd"];
        graphLayer.path = graphPath;
        [self.layer addSublayer:graphLayer];
  
}

- (NSArray *)handleMyNeedPointsWithPlot:(YXPPlot *)plot{
    NSMutableArray *handlePoints = @[].mutableCopy;
    NSMutableArray *ordinaryPoints = @[].mutableCopy;
    NSMutableArray *specialPoints = @[].mutableCopy;

    for (YXPChartPoint *point in plot.plotValues) {
        if (point.isSpecialPoint) {
            [specialPoints addObject:point];
        }else{
            [ordinaryPoints addObject:point];
        }
    }
    [handlePoints addObject:ordinaryPoints];
    [handlePoints addObject:specialPoints];
    return handlePoints;
}

- (void)drawCircle:(YXPPlot *)plot{
    
    NSArray *afterHandlePoints = [self handleMyNeedPointsWithPlot:plot];
    NSArray *ordinaryPoints = afterHandlePoints[0];
    NSArray *specialPoints = afterHandlePoints[1];
    
    if (afterHandlePoints.count && [ordinaryPoints count]) {
        //一般点 的涂层和操作
        YXPChartPoint *point = ordinaryPoints[0];
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.frame = self.bounds;
        circleLayer.fillColor = point.pointFillColor.CGColor;
        circleLayer.backgroundColor = [UIColor clearColor].CGColor;
        [circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
        [circleLayer setLineWidth:point.strokeWidth];
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        
        for (YXPChartPoint *point in afterHandlePoints[0]) {
            CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.xPoint - 5, point.yPoint - 5, 10, 10));
        }
        
        circleLayer.path = circlePath;
        CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        circleAnimation.duration = 0.4;
        circleAnimation.fromValue = @(0.0);
        circleAnimation.toValue = @(1.0);
        [circleLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.layer addSublayer:circleLayer];
            
            
        });
    }
    
    
    
    //特殊点涂层和操做
    if (specialPoints.count && afterHandlePoints.count) {
        for (YXPChartPoint *point in specialPoints) {
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            circleLayer.frame = self.bounds;
            circleLayer.fillColor = point.pointFillColor.CGColor;
            circleLayer.backgroundColor = [UIColor clearColor].CGColor;
            [circleLayer setStrokeColor:point.pointStrokeColor.CGColor];
            [circleLayer setLineWidth:point.strokeWidth];
            
            CGMutablePathRef circlePath = CGPathCreateMutable();
             CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.xPoint - 6, point.yPoint - 6, 12, 12));
            circleLayer.path = circlePath;
            CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            circleAnimation.duration = 1;
            circleAnimation.fromValue = @(0.2);
            circleAnimation.toValue = @(1.0);
            [circleLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.layer addSublayer:circleLayer];
                
                
            });
        }
    }
    
   
}

- (void)drawGradualColor:(YXPPlot *)plot{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor clearColor].CGColor];
    [self.layer insertSublayer:gradientLayer atIndex:1];
    gradientLayer.hidden = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.fillColor = [UIColor brownColor].CGColor;
    maskLayer.frame = self.bounds;
    maskLayer.masksToBounds = YES;

    
    

    CGMutablePathRef graphPath = CGPathCreateMutable();
    YXPChartPoint *beginPoint = plot.plotValues[0];
    CGPathMoveToPoint(graphPath, NULL, _chartEdgeInsets.left, beginPoint.yPoint);
    
    for (YXPChartPoint *point in plot.plotValues) {
        CGPathAddLineToPoint(graphPath, NULL, point.xPoint, point.yPoint);
    }
    YXPChartPoint *lastPoint = [plot.plotValues lastObject];
    CGPathAddLineToPoint(graphPath, NULL, lastPoint.xPoint, _chartSize.height-_chartEdgeInsets.bottom);
    CGPathAddLineToPoint(graphPath, NULL, _chartEdgeInsets.left, _chartSize.height-_chartEdgeInsets.bottom);
    CGPathCloseSubpath(graphPath);
    
     CGPathRef beginPath = [UIBezierPath bezierPathWithRect:CGRectMake(_chartEdgeInsets.left, _chartSize.height-_chartEdgeInsets.top, 0, _chartSize.height-_chartEdgeInsets.top-_chartEdgeInsets.bottom)].CGPath;
    
//    CGPathRef endPath = [UIBezierPath bezierPathWithRect:CGRectMake(_chartEdgeInsets.left, _chartSize.height-_chartEdgeInsets.top, _chartSize.height-_chartEdgeInsets.left-_chartEdgeInsets.right, _chartSize.height-_chartEdgeInsets.top-_chartEdgeInsets.bottom)].CGPath;
    maskLayer.path = graphPath;
    gradientLayer.mask = maskLayer;
//    self.layer.mask = contentShapeLayer;

//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
//    animation.duration = 3;
//    animation.fromValue = (id)maskLayer.path;
//    animation.toValue = (__bridge id)graphPath;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    [maskLayer addAnimation:animation forKey:@"strokeXAxis"];


}


@end
