//
//  MyLogV2.h
//  MyTools
//
//  Created by Shen on 2023/1/8.
//  abstract: import this file in the pch

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define NSLog(args...) _Log(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
@interface MyLogV2 : NSObject
void _Log(const char *file, int lineNumber, const char *funcName, NSString *format,...);
@end

NS_ASSUME_NONNULL_END
