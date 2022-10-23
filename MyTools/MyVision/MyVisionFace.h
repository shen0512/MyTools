//
//  MyVisionFace.h
//  MyTools
//
//  Created by Shen on 2022/10/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyVisionFace : NSObject
+ (void)detectFace:(UIImage*)image results:(void(^)(NSArray *results))results;
+ (void)detectFaceWithLandmark:(UIImage*)image results:(void(^)(NSDictionary *results))results;

@end

NS_ASSUME_NONNULL_END
