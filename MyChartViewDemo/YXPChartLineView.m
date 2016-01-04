//
//  YXPChartLineView.m
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import "YXPChartLineView.h"



@interface MyShaperLayer : NSObject

@property (nonatomic, strong) CAShapeLayer *layer;

@property (nonatomic, strong) CAAnimation *animation;

@end


@implementation MyShaperLayer



@end

@implementation YXPChartLineView
{
    NSNumber *_yMaxValue;
    
    NSMutableArray *_contentLineData;
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
    _contentLineData = @[].mutableCopy;
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
    [self addXAxisLables];
    
}

- (void)addXAxisLables{

    if (self.xAxisScaleMsgBlock) {
        YXPPlot *plot = _plots[0];
        for (NSInteger i=0;i<plot.plotValues.count ;i++) {
            self.xAxisScaleMsgBlock(i,_plots[0]);

        }
    }
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
         //设置相关动画
         for (id plot in _plots) {
             [self drawPlotWithPlot:plot];
         }
         [self begainStroke];
         //画渐变
         [self drawGradualColor:_plots[0]];

         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             self.layer.sublayers[1].hidden = NO;
         });
     }
    
   
}

- (void)begainStroke{
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    for (MyShaperLayer *layer in _contentLineData) {
        [layer.layer addAnimation:layer.animation forKey:NSStringFromClass([layer.animation class])];
        [self.layer addSublayer:layer.layer];
        if (_pointShowMsgBlock) {
            NSInteger pointIndex = [_contentLineData indexOfObject:layer]%_numberOfScaleXAxis;
            NSInteger plotIndex = [_contentLineData indexOfObject:layer]/_numberOfScaleXAxis;
//            NSLog(@"------%@",)
            self.pointShowMsgBlock(pointIndex,plotIndex ,_plots[plotIndex]);
        }
    }
      });
}

- (void)addANewPlot:(YXPPlot *)plot{
    if (plot) {
        if (!_plots) {
            _plots = [NSMutableArray array];
        }
        [_plots addObject:plot];
      
        
    }
}

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
//    MyShaperLayer *layer = [[MyShaperLayer alloc] init];
//    layer.layer = graphLayer;
//    layer.animation = animation;
//    [_contentLineData addObject:layer];
    [graphLayer addAnimation:animation forKey:@"strokeEnd"];
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

        for (YXPChartPoint *point in plot.plotValues) {
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            CGFloat radium = point.isSpecialPoint?6:5;
            circleLayer.frame = CGRectMake(point.xPoint - radium, point.yPoint - radium, radium*2, radium*2);
            circleLayer.fillColor = point.pointFillColor.CGColor;
            circleLayer.backgroundColor = [UIColor clearColor].CGColor;
            [circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
            [circleLayer setLineWidth:point.strokeWidth];
            
            CGMutablePathRef circlePath = CGPathCreateMutable();
            CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(0, 0, radium*2, radium*2));
            circleLayer.path = circlePath;
            
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyAnimation.duration = 1;
            keyAnimation.values = @[@0.0,@.6,@1.3,@.6,@1];
            keyAnimation.keyTimes = @[@0,@0.3,@0.55,@0.75,@1.0];
            keyAnimation.repeatCount = INFINITY;
            [circleLayer addAnimation:keyAnimation forKey:@"kScale"];

            MyShaperLayer *layer = [[MyShaperLayer alloc] init];
            layer.layer = circleLayer;
            layer.animation = keyAnimation;
            [_contentLineData addObject:layer];
            
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

    maskLayer.path = graphPath;
    gradientLayer.mask = maskLayer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 3;
    animation.fromValue = (id)maskLayer.path;
    animation.toValue = (__bridge id)graphPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:animation forKey:@"strokeXAxis"];


}

- (void)updateChartLine{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeAllAnimations];

    }
    self.layer.sublayers = nil;
    _contentLineData = @[].mutableCopy;
    [self startDrawChartLineViewWithAnimation:YES];
    
}


@end


