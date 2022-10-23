//
//  MyDebug.h
//  MyTools
//
//  Created by Shen on 2022/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDebug : NSObject
- (instancetype)init:(NSString*)level;
- (NSString*)getLevelInfo;
- (void)changeLevel:(NSString *)level;
- (void)showDebug:(NSString*)msg;
- (void)showInfo:(NSString*)msg;
- (void)showWarning:(NSString*)msg;
- (void)showError:(NSString*)msg;

@end

NS_ASSUME_NONNULL_END
