//
//  MyVisionPersonSegmentation.h
//  MyTools
//
//  Created by Shen on 2022/12/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVisionPersonSegmentation : NSObject
+ (void)detect:(UIImage*)image result:(void(^)(UIImage *result))result;

@end

NS_ASSUME_NONNULL_END
