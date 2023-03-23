//
//  MyAuthenticator.h
//  MyTools
//
//  Created by Shen on 2023/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAuthenticator : NSObject
+ (void)authenticator:(void(^)(BOOL success, NSString  * _Nullable error))result;
@end

NS_ASSUME_NONNULL_END
