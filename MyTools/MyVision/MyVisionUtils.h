//
//  MyVisionUtils.h
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVisionUtils : NSObject
+ (CGRect)bboxVision2UIImage:(UIImage*)image bbox:(CGRect)bbox;
+ (CGPoint)landmarkVision2UIImage:(UIImage*)image :(CGRect)bbox :(CGPoint)point;
+ (CGPoint)pointVision2UIImage:(UIImage*)image :(CGPoint)point;
+ (CGPoint)pointUIImage2Vision:(UIImage*)image :(CGPoint)point;
+ (UIImage*)perspectiveCorrection:(UIImage*)image points:(NSDictionary*)points;
@end

NS_ASSUME_NONNULL_END
