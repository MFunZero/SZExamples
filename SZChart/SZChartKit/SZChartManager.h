//
//  SZChartManager.h
//  SZChart
//
//  Created by Shuze Pang on 2017/3/28.
//  Copyright © 2017年 suze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SZChartLineImage.h"



@interface SZChartManager : NSObject

+ (SZChartManager *)sharedInstance;

- (UIImage *)drawImage:(CGRect)frame withType:(SZChartType) type withScale:(CGFloat)scale;

@end
