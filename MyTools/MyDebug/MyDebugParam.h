//
//  MyDebugParam.h
//  MyTools
//
//  Created by Shen on 2024/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define LoggerLevelStr(enum) [@[@"DEBUG", @"ERROR", @"WARNING", @"INFO"] objectAtIndex:enum]

typedef NS_ENUM(NSInteger, LoggerLevel){
    LoggerLevelDebug=0,
    LoggerLevelError,
    LoggerLevelWarning,
    LoggerLevelInfo,
    LoggerLevelNoShow
};

@interface MyDebugParam : NSObject
@property (nonatomic) NSString *className;
@property (nonatomic) LoggerLevel loggerLevel;
@property (nonatomic) BOOL showLog;
@property (nonatomic) BOOL saveLog;
@property (nonatomic) BOOL saveFile;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
