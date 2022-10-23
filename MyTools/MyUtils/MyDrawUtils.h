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
+ (UIImage*)createCanvas:(CGFloat)width :(CGFloat)height;
+ (UIImage*)drawRect:(UIImage*)canvas :(CGRect)rect;
+ (UIImage*)drawPoint:(UIImage*)canvas :(CGPoint)point;
+ (UIImage*)drawPointByPoints:(UIImage*)canvas :(NSArray*)points;
@end

NS_ASSUME_NONNULL_END
