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
+ (CGRect)visionBbox2UIImageBbox:(UIImage*)image bbox:(CGRect)bbox;
+ (CGPoint)visionPoint2UIImagePoint:(UIImage*)image :(CGRect)bbox :(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
