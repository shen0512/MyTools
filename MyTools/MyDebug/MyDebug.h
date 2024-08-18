//
//  MyDebug.h
//  MyTools
//
//  Created by Shen on 2022/7/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MyDebugParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDebug : NSObject
+ (instancetype)sharedInstance;

-(NSString*_Nullable)prettyPrintedJSON:(id)json;

-(void)showLog:(NSString*)msg level:(LoggerLevel)level;
-(void)saveJSON:(id)json filename:(NSString*)filename extension:(NSString*)extension foldername:(NSString* _Nullable)foldername;
-(void)saveImg:(UIImage*)img filename:(NSString*)filename extension:(NSString*)extension foldername:(NSString* _Nullable)foldername;
-(void)saveFile:(NSString*)filename extension:(NSString*)extension foldername:(NSString* _Nullable)foldername preprocess:(NSData*(^)(void))preprocess;

@end

NS_ASSUME_NONNULL_END
