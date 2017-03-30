//
//  SZChartLineImage.h
//  SZChart
//
//  Created by Shuze Pang on 2017/3/28.
//  Copyright © 2017年 suze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum SZChartType {
    SZChartTypeSolidLine = 0,
    SZChartTypeSmoothLine = 1,
    
}SZChartType;


@interface SZChartLineImage : NSObject

@property (nonnull,nonatomic) NSArray<NSNumber *> *values;

@property (nullable,nonatomic) NSArray<NSString *> *horizionCoordinateValues;

@property (nullable,nonatomic) NSArray<NSString *> *verticalCoordinateValues;

@property (nonnull,nonatomic) NSNumber *maxValue;

@property (nonatomic) CGFloat strokeWidth;

@property (nullable,nonatomic) UIColor *strokeColor;

@property (nullable,nonatomic) UIColor *fillColor;

@property (nonatomic) BOOL smooth;


- (UIImage * _Nonnull)drawImage:(CGRect)frame scale:(CGFloat)scale withType:(SZChartType) type;

- (instancetype)init ;

@end












