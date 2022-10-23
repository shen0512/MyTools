//
//  MyDrawUtils.m
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import "MyDrawUtils.h"

@implementation MyDrawUtils

+ (UIImage*)createCanvas:(CGFloat)width :(CGFloat)height{
    /**
     @brief 建立透明畫布
     @return 透明畫布
     */
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *bgColor = [UIColor colorWithWhite:1 alpha:1];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return result;
}

+ (UIImage*)drawRect:(UIImage*)canvas :(CGRect)rect{
    /**
     @brief 將矩形在畫布上
     @param canvas 畫布
     @param rect 矩形
     @return 畫矩形後的圖片
     */
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    
    // 設定透明背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];

    // 設定矩形線條寬度及線條顏色
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 5);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    // 結束
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage*)drawPoint:(UIImage*)canvas :(CGPoint)point{
    /**
     @brief 將點畫在畫布上
     @param canvas 畫布
     @param point 座標點
     @return 畫座標點後的圖片
     */
    
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    
    // 設定透明背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];
    
    // 設定矩形線條寬度及線條顏色
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(context, 10);
    CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 結束
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage*)drawPointByPoints:(UIImage*)canvas :(NSArray*)points{
    
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    
    // 設定透明背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];
    
    // 設定矩形線條寬度及線條顏色
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(context, 5);
    for(int i=0; i<[points count]; i++){
        CGPoint point = [points[i] CGPointValue];
        CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    // 結束
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
