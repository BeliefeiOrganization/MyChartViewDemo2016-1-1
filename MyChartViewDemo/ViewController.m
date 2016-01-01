//
//  ViewController.m
//  MyChartViewDemo
//
//  Created by 段龙飞 on 15/12/30.
//  Copyright © 2015年 段龙飞. All rights reserved.
//

#import "ViewController.h"

#import "YXPChartLineView.h"
#import "YXPChartPoint.h"
#import "YXPPlot.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet YXPChartLineView *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.chartView.numberOfScaleXAxis = 6;
    self.chartView.numberOfScaleYAxis = 2;
    self.chartView.chartEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 20);
    
    [self addAnewPlot:[UIColor yellowColor]];
    
    NSLog(@"----%@",NSStringFromCGSize(self.chartView.bounds.size));
//    [self.chartView startDrawChartLineViewWithAnimation:YES];

    
}

- (void)addAnewPlot:(UIColor *)strokeColr{
    NSMutableArray *newPlotArray_1 = [NSMutableArray array];
    NSMutableArray *newPlotArray_2 = [NSMutableArray array];

    for (NSInteger i = 0; i < 6; i++) {
        YXPChartPoint *point = [[YXPChartPoint alloc] init];
        YXPChartPoint *point2 = [[YXPChartPoint alloc] init];
        point2.pointStrokeColor = [UIColor colorWithRed:0.47 green:0.9 blue:.3 alpha:1.0];
        if (i==3) {
            point.isSpecialPoint = YES;
            point.pointStrokeColor =[UIColor whiteColor];
            point.strokeWidth = 2;
            
            point2.isSpecialPoint = YES;
            point2.pointStrokeColor =[UIColor whiteColor];
            point2.strokeWidth = 2;
        }
        CGFloat height = ABS(arc4random()%80)+20 ;
        point.yValue = [NSNumber numberWithFloat:height];

        point2.yValue = [NSNumber numberWithFloat:height - 10];
        
        [newPlotArray_2 addObject:point2];

        [newPlotArray_1 addObject:point];
    }
    
    YXPPlot *newPlot_1 = [[YXPPlot alloc] init];
    YXPPlot *newPlot_2 = [[YXPPlot alloc] init];

    newPlot_1.plotValues = newPlotArray_1;
    newPlot_2.plotValues = newPlotArray_2;
    newPlot_2.plotStrokeColor = [UIColor blackColor];
    [self.chartView addANewPlot:newPlot_1];
    [self.chartView addANewPlot:newPlot_2];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"*****%@***",NSStringFromCGSize(self.chartView.bounds.size));
    self.chartView.chartSize = self.chartView.bounds.size;

    [self.chartView startDrawChartLineViewWithAnimation:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
