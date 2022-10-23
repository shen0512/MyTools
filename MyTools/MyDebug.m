//
//  MyDebug.m
//  MyTools
//
//  Created by Shen on 2022/7/3.
//

#import "MyDebug.h"

typedef NS_ENUM(NSInteger, DebugLevel){
    debugLevel=1,
    infoLevel=2,
    warningLevel=3,
    errorLevel=4
};

@interface MyDebug()
@property (nonatomic) DebugLevel level;

@end

@implementation MyDebug

- (instancetype)init:(NSString*)level{
    /**
     @brief
     @param level debug level
     */
    self = [super init];
    [self changeLevel:level];
    
    return self;
}

- (NSString*)getLevelInfo{
    /**
     @brief
     */
    return @"level support: debug, info, warning, error";
}

- (void)changeLevel:(NSString *)level{
    /**
     @brief setting debug level
     @param level debug level
     */
    
    if([level isEqualToString:@"debug"]){
        self.level = debugLevel;
    }else if([level isEqualToString:@"info"]){
        self.level = infoLevel;
    }else if([level isEqualToString:@"warning"]){
        self.level = warningLevel;
    }else if([level isEqualToString:@"error"]){
        self.level = errorLevel;
    }else{
        NSLog(@"輸入錯誤 debug level, 因此使用預設 debug level(info)");
        self.level = infoLevel;
    }
}


- (void)showDebug:(NSString*)msg{
    if(self.level > debugLevel) return;
    NSLog(@"%@", msg);
}

- (void)showInfo:(NSString*)msg{
    if(self.level > infoLevel) return;
    NSLog(@"%@", msg);
}

- (void)showWarning:(NSString*)msg{
    if(self.level > warningLevel) return;
    NSLog(@"%@", msg);
}

- (void)showError:(NSString*)msg{
    if(self.level > errorLevel)return;
    NSLog(@"%@", msg);
}

@end
