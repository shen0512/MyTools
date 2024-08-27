//
//  MyDebugMonitor.h
//  MyTools
//
//  Created by Shen on 2024/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDebugMonitor : NSObject
+(long long unsigned)MemoryUsage;
+(unsigned int)CPUUsage;
+(CGFloat)APPCPUUsage;
+(NSString*)DeviceName;
+(NSString*)IOSVersion;

@end

NS_ASSUME_NONNULL_END
