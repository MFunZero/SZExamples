//
//  SZChartLineImage.m
//  SZChart
//
//  Created by Shuze Pang on 2017/3/28.
//  Copyright © 2017年 suze. All rights reserved.
//

#import "SZChartLineImage.h"

/**
 *待解决问题
 1:values.count < cells.count 时：
 cells的绘制point数组追加绘制
 seprator的绘制point数组追加绘制
 values.count > cells.count 时：
 断言报错
 2:竖向坐标轴数值灵活定义:
 maxValue:values中最大值
 minValue:0 --------缺陷：无法输入负值
 3:坐标系参数传递
 横向--
 竖向--
 4:绘制动画
 折线动画：---(底部是否有遮罩层)
 曲线动画：----(底部是否有遮罩层)
 seprator动画
 坐标轴动画
 *
 */


@implementation SZChartLineImage
{
    SZChartType _type;
    CGFloat topMargin;
    CGFloat leftMargin;
    CGFloat rightMargin;
    CGFloat bottomMargin;
    CGFloat pointDistance;
    CGFloat vercitalLineLeftMargin;
}


- (instancetype)init {
    if (self = [super init]) {
        _strokeColor = [UIColor whiteColor];
        _strokeWidth = 1.0;
        _smooth = YES;
        topMargin = 20.0;
        leftMargin = 30.0;
        rightMargin = 50.0;
        bottomMargin = 40.0;
        pointDistance = 40.0;
        vercitalLineLeftMargin = 5.0;
    }
    return self;
}

- (NSNumber *)maxValue {
    return _maxValue ? _maxValue : [NSNumber numberWithFloat:[[_values valueForKeyPath:@"@max.floatValue"] floatValue]];
}

- (UIImage *)drawImage:(CGRect)frame scale:(CGFloat)scale withType:(SZChartType)type {
    NSAssert(_values.count > 0, @"SZChartLineImage --- must assign values property which is an array");
    _type = type;
    

    NSUInteger valuesCount = _values.count;
    
    if (_horizionCoordinateValues) {
        NSAssert(_values.count <= _horizionCoordinateValues.count, @"SZChartLineImage --- must assign values property which _values.count <= _horizionCoordinateValues.count");
        pointDistance = (frame.size.width - leftMargin-rightMargin) / (_horizionCoordinateValues.count-1);
    }else{
        pointDistance = (frame.size.width - leftMargin-rightMargin) / (valuesCount-1);
    }
    NSMutableArray<NSValue *> *points = [NSMutableArray array];
    CGFloat maxValue = self.maxValue.floatValue;
    
    
    
    [_values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ratioY = number.floatValue / maxValue;
        CGFloat offsetY = ratioY == 0.0 ? topMargin - _strokeWidth/2: topMargin + _strokeWidth/2;
        NSValue *pointValue = [NSValue valueWithCGPoint:(CGPoint){
            (float)idx * pointDistance+leftMargin,
            (frame.size.height - topMargin - bottomMargin) * (1-ratioY) + offsetY
        }];
        [points addObject:pointValue];
    }];
    UIGraphicsBeginImageContextWithOptions(frame.size, false, scale);
    UIBezierPath *path = [self calculatePathWithPoints:points frame:frame];
    path.lineWidth = _strokeWidth;
    

    if (_strokeColor) {
        [_strokeColor setStroke];
        [path stroke];
    }

    [self analysis:points frame:frame];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)analysis:(NSArray *)points frame:(CGRect) frame {

    if (_horizionCoordinateValues) {
        if (_values.count == _horizionCoordinateValues.count) {
            [self drawSepWithHorizonWithPoints:points frame:frame];
            [self drawVercitalLineWithPoints:points frame:frame];

        }else if (_values.count < _horizionCoordinateValues.count){
            NSMutableArray<NSValue *> *newPoints = points.mutableCopy;
            for (int i=(int)points.count; i<_horizionCoordinateValues.count; i++) {
                NSValue *pointValue = [NSValue valueWithCGPoint:(CGPoint){
                    (float)i * pointDistance+leftMargin,
                    0
                }];
                [newPoints addObject:pointValue];
            }
            [self drawSepWithHorizonWithPoints:newPoints frame:frame];
            [self drawVercitalLineWithPoints:newPoints frame:frame];

        }
    }else{
        [self drawSeperatorWithPoints:points frame:frame];
        [self drawVercitalLineWithPoints:points frame:frame];

    }
}

- (void)drawSepWithHorizonWithPoints:(NSArray *)points frame:(CGRect) frame {
    UIColor *cb = [UIColor whiteColor];
    
    [points enumerateObjectsUsingBlock:^(NSValue  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint p = obj.CGPointValue;
        CGPathMoveToPoint(path, NULL, p.x-0.5, topMargin);
        CGPathAddLineToPoint(path, NULL, p.x+0.5, topMargin);
        //        CGPathAddLineToPoint(path, NULL, p.x, p.y);
        CGPathAddLineToPoint(path, NULL, p.x-0.5, frame.size.height-bottomMargin);
        CGPathAddLineToPoint(path, NULL, p.x-0.5, topMargin);
        
        CGPathCloseSubpath(path);
        [self drawLinearGradient: path startColor:[[cb colorWithAlphaComponent:0.75] CGColor] endColor:[[cb colorWithAlphaComponent:0.05] CGColor]];
        CGPathRelease(path);
        
        
        NSString *str = _horizionCoordinateValues[idx];
        UIFont *font = [UIFont fontWithName:@"Arial" size:13.0];
        NSDictionary *dic=@{
                            NSFontAttributeName:font,
                            NSForegroundColorAttributeName:_strokeColor
                            };
        //绘制文本的俩种方式
        //            [str drawInRect:rect withAttributes:dic];
        CGSize strSize = [self sizeWith:str withConstraint:CGSizeMake(pointDistance, bottomMargin/2) withFontSize:14 isSingleLine:false];
        //以点绘制
        CGPoint center = CGPointMake(p.x - strSize.width/2, frame.size.height-bottomMargin*3/4);
        [str drawAtPoint:center withAttributes:dic];
         
    }];
}

- (void)drawVercitalLineWithPoints:(NSArray *)points frame:(CGRect) frame {
    if (_verticalCoordinateValues) {
        CGPoint p = ((NSValue *)points.lastObject).CGPointValue;
        CGFloat pointx = p.x + vercitalLineLeftMargin;
        [_verticalCoordinateValues enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat radioY = (frame.size.height-bottomMargin-topMargin)*(idx)/(_verticalCoordinateValues.count-1);
            CGFloat pointY = frame.size.height-bottomMargin-radioY;
            
            NSString *str = _verticalCoordinateValues[idx];
            UIFont *font = [UIFont fontWithName:@"Arial" size:12.0];
            NSDictionary *dic=@{
                                NSFontAttributeName:font,
                                NSForegroundColorAttributeName:_strokeColor
                                };
            //绘制文本的俩种方式
            //            [str drawInRect:rect withAttributes:dic];
            CGSize strSize = [self sizeWith:str withConstraint:CGSizeMake(rightMargin-vercitalLineLeftMargin*2, bottomMargin) withFontSize:13 isSingleLine:false];
            //以点绘制
            CGPoint center = CGPointMake(pointx, pointY-strSize.height/2);
            [str drawAtPoint:center withAttributes:dic];
        }];
    }
}

- (void)drawSeperatorWithPoints:(NSArray *)points frame:(CGRect) frame {
    UIColor *cb = [UIColor whiteColor];

    [points enumerateObjectsUsingBlock:^(NSValue  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint p = obj.CGPointValue;
        CGPathMoveToPoint(path, NULL, p.x-0.5, topMargin);
        CGPathAddLineToPoint(path, NULL, p.x+0.5, topMargin);
//        CGPathAddLineToPoint(path, NULL, p.x, p.y);
        CGPathAddLineToPoint(path, NULL, p.x-0.5, frame.size.height-bottomMargin);
        CGPathAddLineToPoint(path, NULL, p.x-0.5, topMargin);

        CGPathCloseSubpath(path);
        [self drawLinearGradient: path startColor:[[cb colorWithAlphaComponent:0.75] CGColor] endColor:[[cb colorWithAlphaComponent:0.05] CGColor]];
        CGPathRelease(path);
    
        /*
        NSString *str = @"Hello";
        UIFont *font = [UIFont fontWithName:@"Arial" size:13.0];
        NSDictionary *dic=@{
                        NSFontAttributeName:font,
                        NSForegroundColorAttributeName:_strokeColor
                        };
        //绘制文本的俩种方式
//            [str drawInRect:rect withAttributes:dic];
        CGSize strSize = [self sizeWith:str withConstraint:CGSizeMake(pointDistance, bottomMargin/2) withFontSize:14 isSingleLine:false];
        //以点绘制
        CGPoint center = CGPointMake(p.x - strSize.width/2, frame.size.height-bottomMargin*3/4);
        [str drawAtPoint:center withAttributes:dic];
    */
    }];

}

- (UIBezierPath *)calculatePathWithPoints:(NSArray *)points frame:(CGRect) frame {
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    UIBezierPath *fillBottom = [[UIBezierPath alloc] init];
    
    __block CGPoint p1 = [points[0] CGPointValue];
    __block CGPoint endP = [points[points.count-1] CGPointValue];

    CGPoint startPoint = (CGPoint){p1.x,frame.size.height-bottomMargin};
    CGPoint endPoint = (CGPoint){endP.x,frame.size.height-bottomMargin};
    [fillBottom moveToPoint:endPoint];
    [fillBottom addLineToPoint:startPoint];

    [linePath moveToPoint:p1];
    [fillBottom addLineToPoint:p1];
    
    if (points.count == 2) {
        CGPoint p2 = [points[1] CGPointValue];
        [linePath addLineToPoint:p2];
        [fillBottom addLineToPoint:p2];
        if (_fillColor) {
            [_fillColor setFill];
            [fillBottom fill];
            
        }
        
        return linePath;
    }
    
    [points enumerateObjectsUsingBlock:^(NSValue  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = obj.CGPointValue;
        
        if (_type == SZChartTypeSmoothLine) {
            CGFloat deltaX = p.x - p1.x;
            CGFloat controlPointX = p1.x + (deltaX / 2);
            CGPoint controlPoint1 = (CGPoint){controlPointX, p1.y};
            CGPoint controlPoint2 = (CGPoint){controlPointX, p.y};
            
            
            [linePath addCurveToPoint:p controlPoint1:controlPoint1 controlPoint2:controlPoint2];
            [fillBottom addCurveToPoint:p controlPoint1:controlPoint1 controlPoint2:controlPoint2];
            
//            [[UIColor whiteColor] setFill];
//            [fillBottom fill];
        
        }else{
            [linePath addLineToPoint:p];
            [fillBottom addLineToPoint:p];
            
            CGRect ovalRect = CGRectMake(p.x-2.5, p.y-2.5, 5.0, 5.0);
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
            path.lineWidth = 5;
            [[UIColor whiteColor] setFill];
            [path fill];
        }
        p1 = p;

    }];
    if (_fillColor) {
        [_fillColor setFill];
        [fillBottom fill];
    }
    

    return linePath;
}

- (void)drawLinearGradient:(CGMutablePathRef)path startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 0.5 , 1.0 };
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *colors = @[(__bridge id)endColor,(__bridge id)startColor,(__bridge id)endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);

    
    //设定线性变化方向
    CGPoint startPoint = CGPointMake(0,0);
    CGPoint endPoint = CGPointMake(0, CGRectGetMaxY(pathRect));

    CGContextSaveGState(context);
    //裁剪，限定区域
    CGContextClipToRect(context, pathRect);
    CGContextAddPath(context, path);
    
    /**线性绘制*/
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    /**径向变化绘制*/
//    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect)/2);
//    CGContextDrawRadialGradient(context, gradient, center, 0, center, center.y, 0);
    CGContextRestoreGState(context);
  

 
    
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextClosePath(context);
}


- (CGSize)sizeWith:(NSString *)str withConstraint:(CGSize)constraint withFontSize:(CGFloat)fontSize isSingleLine:(BOOL)isSingle{
    UIFont *font=[UIFont systemFontOfSize:fontSize];
    NSDictionary *attrs=@{NSFontAttributeName:font};
    if (isSingle) {
        /**根据attributes计算单行文本宽度*/
        CGSize s1=[str sizeWithAttributes:attrs];
        return s1;
    }else{
    /**计算多行文本宽度*/
    CGSize s=[str boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine |
              NSStringDrawingUsesLineFragmentOrigin |
              NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return s;
    }
}


- (void)keyFrameAnimationWithPath:(UIBezierPath *)path {
    CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFA.path = path.CGPath;
//    keyFA.keyTimes = @[@(0.0),@(0.5),@(0.9),@(2)];
    keyFA.duration = 0.3f;
    //重复次数，小于0无限重复
    keyFA.repeatCount = 1;
    keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFA.fillMode = kCAFillModeForwards;
    keyFA.calculationMode = kCAAnimationPaced;
    keyFA.rotationMode = kCAAnimationRotateAuto;
    
    //结束后是否移除动画
    keyFA.removedOnCompletion = NO;
    
    //添加动画
    
}

@end








