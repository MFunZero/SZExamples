//
//  SZChartManager.m
//  SZChart
//
//  Created by Shuze Pang on 2017/3/28.
//  Copyright © 2017年 suze. All rights reserved.
//

#import "SZChartManager.h"

//static dispatch_once_t onceToken;

static SZChartManager *instance = nil;
@implementation SZChartManager



/**
 不完全单例
 @return 实例
 */
/*
+ (SZChartManager *)sharedInstance {
    @synchronized (self) {
        instance = [[SZChartManager alloc]init];
    }
    return instance;
}
*/

#pragma mark:---完全单例
/**
 *完全单例
 *为单例对象实现一个静态实例,然后设置成nil，
 *构造方法检查静态实例是否为nil，是则新建并返回一个实例，
 *重写allocWithZone方法，用来保证其他人直接使用alloc和init试图获得一个新实例的时候不会产生一个新实例，
 *适当实现copyWithZone，,retain,retainCount,release和autorelease 等方法
 *
 @return 实例
 */
+ (SZChartManager *)sharedInstance {
    @synchronized(self){
        /**
         GCD实现单例
         static dispatch_once_t onceToken;

         dispatch_once(&onceToken, ^{
         //because has rewrited allocWithZone use NULL avoid endless loop .
         _sharedInstance = [[super allocWithZone:NULL] init];
         });
         */
        
        if (nil == instance) {
            instance = [[super allocWithZone:nil] init];// 避免死循环
            // 如果 在单例类里面重写了 allocWithZone 方法 ，在创建单例对象时 使用 [[DataHandle alloc] init] 创建，会死循环。
        }
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [SZChartManager sharedInstance];
}

- (id)copy {
    return  self;
}

- (id)mutableCopy {
    return self;
}

+ (instancetype)alloc {
    return [SZChartManager sharedInstance];
}


#pragma mark:---生成image
- (UIImage *)drawImage:(CGRect)frame withType:(SZChartType)type withScale:(CGFloat)scale {
    switch (type) {
        case SZChartTypeSolidLine:
            {
                SZChartLineImage *img = [[SZChartLineImage alloc] init];
                img.strokeWidth = 1.0;
                img.strokeColor = [UIColor whiteColor];
                img.horizionCoordinateValues = @[@"0:00",@"2:00",@"4:00",@"6:00",@"8:00",@"10:00",@"12:00",@"14:00",@"16:00",@"18:00",@"18:00",@"18:00",@"20:00",@"22:00",@"24:00"];
                img.values = @[@1,@4,@2,@7,@0,@3,@10];
                img.verticalCoordinateValues = @[@"0.0GB",@"0.5GB",@"1GB"];
                return [img drawImage:frame scale:scale withType:SZChartTypeSolidLine];
            }
            break;
        case SZChartTypeSmoothLine:
        {
            SZChartLineImage *img = [[SZChartLineImage alloc] init];
            img.strokeWidth = 1.0;
            img.strokeColor = [UIColor whiteColor];
            img.horizionCoordinateValues = @[@"4:00",@"6:00",@"8:00",@"10:00",@"12:00",@"14:00",@"16:00",@"18:00"];
            img.values = @[@1,@4,@2,@7,@0,@3,@10];
            img.verticalCoordinateValues = @[@"0.0GB",@"0.5GB",@"1GB"];
            
            img.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
            return [img drawImage:frame scale:scale withType:SZChartTypeSmoothLine];
        }
            break;
    }
}


- (UIColor *)randomColor{
    CGFloat hue = ( (CGFloat)(arc4random() % 256) / 256.0 );
    CGFloat saturation = ( (CGFloat)(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( (CGFloat)(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithRed:hue green:saturation blue:brightness alpha:1.0];
}

















@end
