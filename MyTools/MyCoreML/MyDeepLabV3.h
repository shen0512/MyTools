//
//  MyDeepLabV3.h
//  MyTools
//
//  Created by Shen on 2022/11/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreML/CoreML.h>
#import <Vision/Vision.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDeepLabV3 : NSObject
- (instancetype)init;
- (void)inference:(UIImage*)image result:(void(^)(MLMultiArray *result))result;
@end

NS_ASSUME_NONNULL_END
