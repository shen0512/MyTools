//
//  MyServiceTool.h
//  MyTools
//
//  Created by Shen on 2022/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyServiceTool : NSObject
- (instancetype)init:(NSString*)url :(BOOL)skipSSL;
- (NSDictionary*)doPost:(NSString*)param :(NSDictionary*)jsonBody;
- (NSDictionary*)doPostMedia:(NSString*)param :(NSDictionary*)jsonBody :(NSData*)data;
- (NSDictionary*)doPostMedia2:(NSString*)param :(NSDictionary*)jsonBody :(NSData*)data;
@end

NS_ASSUME_NONNULL_END
