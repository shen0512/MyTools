//
//  MyVisionRectangle.h
//  MyTools
//
//  Created by Shen on 2022/10/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVisionRectangle : NSObject
+ (void)detect:(UIImage*)image results:(void(^)(NSArray * _Nullable results))results;

@end

NS_ASSUME_NONNULL_END
