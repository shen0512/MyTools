//
//  MyDrawUtils.m
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import "MyDrawUtils.h"
#import "NSString+Utils.h"

@implementation MyDrawUtils

+ (UIImage*)createCanvas:(CGFloat)width height:(CGFloat)height bgColor:(UIColor* _Nullable)bgColor{
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(bgColor){
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, width, height));
    }
    
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return result;
}

+ (UIImage*)drawBbox:(UIImage*)canvas bbox:(CGRect)bbox bboxColor:(UIColor*)bboxColor{
    
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];

    [bboxColor setStroke];
    CGContextSetLineWidth(context, 5);
    CGContextAddRect(context, bbox);
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage*)drawPoint:(UIImage*)canvas point:(CGPoint)point pointColor:(UIColor*)pointColor{
    
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];
    
    [pointColor setStroke];
    CGContextSetLineWidth(context, 10);
    CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage*)drawText:(UIImage*)canvas text:(NSString*)text attributes:(NSDictionary*)attributes{
    CGPoint position = [attributes[@"position"] CGPointValue];
    UIFont *textFont = attributes[@"font"];
    UIColor *textColor = attributes[@"color"];
    UIColor *bgColor = attributes[@"bgColor"];
    
    NSDictionary *textFontAttributes = @{NSFontAttributeName:textFont};
    CGFloat textW = [text stringWidth:textFont];
    CGFloat textH = [text stringHeight:textFont];
    
    UIGraphicsBeginImageContext(CGSizeMake(canvas.size.width, canvas.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [canvas drawAtPoint:CGPointMake(0, 0)];
    
    // background color
    if(bgColor){
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextFillRect(context, CGRectMake(position.x, position.y, textW, textH));
    }
    
    // draw text
    CGContextSetFillColorWithColor(context, textColor.CGColor);
    [text drawAtPoint:CGPointMake(position.x, position.y) withAttributes:textFontAttributes];
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
