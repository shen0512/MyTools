//
//  MyDrawUtils.h
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDrawUtils : NSObject
+ (UIImage*)createCanvas:(CGFloat)width height:(CGFloat)height bgColor:(UIColor* _Nullable)bgColor;
+ (UIImage*)drawBbox:(UIImage*)canvas bbox:(CGRect)bbox bboxColor:(UIColor*)bboxColor;
+ (UIImage*)drawPoint:(UIImage*)canvas point:(CGPoint)point pointColor:(UIColor*)pointColor;
+ (UIImage*)drawText:(UIImage*)canvas text:(NSString*)text attributes:(NSDictionary*)attributes;
@end

NS_ASSUME_NONNULL_END
