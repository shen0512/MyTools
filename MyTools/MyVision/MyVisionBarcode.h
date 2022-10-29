//
//  MyVisionBarcode.h
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyVisionBarcode : NSObject
+ (void)detect:(UIImage*)image results:(void(^)(NSArray *results))results;
+ (void)detectWithMaxConf:(UIImage*)image results:(void(^)(NSDictionary * _Nullable results))results;

@end

NS_ASSUME_NONNULL_END
