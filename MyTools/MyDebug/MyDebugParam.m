//
//  MyDebugParam.m
//  MyTools
//
//  Created by Shen on 2024/8/17.
//

#import "MyDebugParam.h"

#define CLASSNAMEKEY @"CLASSNAME"
#define SHOWLOGKEY @"SHOWLOG"
#define SAVELOGKEY @"SAVELOG"
#define SAVEFILEKEY @"SAVEFILE"

@implementation MyDebugParam

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        if(![dictionary isKindOfClass:[NSDictionary class]])return nil;
        
        if(dictionary[CLASSNAMEKEY]) self.className = dictionary[CLASSNAMEKEY];
        if(dictionary[SHOWLOGKEY]) self.showLog = [dictionary[SHOWLOGKEY] boolValue];
        if(dictionary[SAVELOGKEY]) self.showLog = [dictionary[SAVELOGKEY] boolValue];
        if(dictionary[SAVEFILEKEY]) self.showLog = [dictionary[SAVEFILEKEY] boolValue];
    }
    
    return self;
}
-(instancetype)init{
    self = [super init];
    
    if(self){
        self.className = @"";
        self.showLog = NO;
        self.saveLog = NO;
        self.saveFile = NO;
    }
    
    return self;
}
-(NSDictionary*)dictionary{
    return @{CLASSNAMEKEY:self.className,
             SHOWLOGKEY:@(self.showLog),
             SAVELOGKEY:@(self.saveLog),
             SAVEFILEKEY:@(self.saveFile)};
}


@end
