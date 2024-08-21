//
//  MyDebug.m
//  MyTools
//
//  Created by Shen on 2022/7/3.
//

#import "MyDebug.h"

#define DEFAULTROOT @"DebugRoot"
#define DEBUGFILENAME @"DebugParam"
#define DEBUGFILEEXTENSION @"data"

@interface MyDebug()
@property (nonatomic) BOOL openDebug;

@property (strong, nonatomic) NSString *debugRoot;

@property (strong, nonatomic) NSDictionary<NSString*, MyDebugParam*>* myDebugParams;
@property (strong, nonatomic) NSString* acceptFramework;
@property (strong, nonatomic) NSArray* acceptClasses;
@property (nonatomic) LoggerLevel loggerLevel;

@property (strong, nonatomic) UIButton *debugBtn;
@property (strong, nonatomic) UITextView *debugView;

@end

@implementation MyDebug

+(instancetype)sharedInstance{
    static MyDebug *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyDebug alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.acceptFramework = @"";
        self.acceptClasses = @[];
        self.loggerLevel = LoggerLevelNoShow;
        
        NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if(!self.acceptFramework || [self.acceptFramework isEqualToString:@""]){
            self.debugRoot = [docpath stringByAppendingPathComponent:DEFAULTROOT];
        }else{
            self.debugRoot = [docpath stringByAppendingPathComponent:self.acceptFramework];
        }
        NSString *startTime = [self getNowTime:@"yyyyMMdd_HHmmss"];
        self.debugRoot = [self.debugRoot stringByAppendingPathComponent:startTime];
        [self createFolder:self.debugRoot];
        
        self.openDebug = YES;
        
    }
    return self;
}

-(void)initDebugView{
    UIWindow *keyWindow;
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
        if(windowScene.activationState == UISceneActivationStateForegroundActive){
            for(UIWindow *window in windowScene.windows){
                keyWindow = window;
                break;
            }
        }
    }
    if(keyWindow == nil){
        return;
    }
    
    UIViewController *topController = keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    CGRect frame = topController.view.frame;
    
    self.debugView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                  frame.size.height*0.65,
                                                                  frame.size.width,
                                                                  frame.size.height*0.35)];
    self.debugView.backgroundColor = [UIColor blackColor];
    self.debugView.textColor = [UIColor greenColor];
    self.debugView.font = [UIFont systemFontOfSize:20];
    self.debugView.editable = NO;
    self.debugView.selectable = NO;
    self.debugView.text = @"";
    [topController.view addSubview:self.debugView];
    
    self.debugBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.debugBtn.frame = CGRectMake(0, self.debugView.frame.origin.y-50, 50, 50);
    self.debugBtn.backgroundColor = [UIColor redColor];
    [self.debugBtn addTarget:self action:@selector(showLogViewClick) forControlEvents:UIControlEventTouchUpInside];
    [topController.view addSubview:self.debugBtn];
}

-(void)showLogViewClick{
    self.debugView.hidden = !self.debugView.hidden;
}

-(void)showLogOnView:(NSString*)msg{
    if(self.debugView == nil) return;
    
    self.debugView.text = [self.debugView.text stringByAppendingFormat:@"%@\r\n",msg];
    if (self.debugView.text.length > 0 ){
        NSRange bottom = NSMakeRange(self.debugView.text.length - 1, 1);
        [self.debugView scrollRangeToVisible:bottom];
    }
}

#pragma mark - debug file process
-(void)loadDebugFile{
    @try {
        NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // load debug file
        NSString *debugFilePath = [docpath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",DEBUGFILENAME,DEBUGFILEEXTENSION]];
        NSData *debugData = [NSData dataWithContentsOfFile:debugFilePath];
        NSArray<NSDictionary*> *json = [NSJSONSerialization JSONObjectWithData:debugData options:0 error:nil];
        NSMutableDictionary *myDebugParams = [NSMutableDictionary new];
        for(NSDictionary *dic in json){
            MyDebugParam *myDebugParam = [[MyDebugParam alloc] initWithDictionary:dic];
            myDebugParams[myDebugParam.className] = myDebugParam;
        }
        self.myDebugParams = myDebugParams;
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

-(void)makeDebugFile{
    @try {
        NSMutableArray *json = [NSMutableArray new];
        for(NSString *key in [self.myDebugParams allKeys]){
            [json addObject:[self.myDebugParams[key] dictionary]];
        }
        
        NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *debugFilePath = [docpath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",DEBUGFILENAME,DEBUGFILEEXTENSION]];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        [data writeToFile:debugFilePath atomically:YES];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

-(NSDictionary<NSString*, NSString*>*)callerParse:(NSString*)callerInfo{
    // Example: 1   UIKit                               0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[callerInfo componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    
    return @{@"stack":[array objectAtIndex:0],
             @"framework":[array objectAtIndex:1],
             @"memory_add":[array objectAtIndex:2],
             @"class":[array objectAtIndex:3],
             @"function":[array objectAtIndex:4]};
}

-(BOOL)verifyCaller:(NSString*)framewokName :(NSString*)module{
    if(!self.openDebug)return NO;
    if(![framewokName isEqualToString:self.acceptFramework])return NO;
    if(![self.acceptClasses containsObject:module])return NO;
    if(!self.myDebugParams) return NO;
    
    return YES;
}

-(BOOL)canShowLog:(NSString*)framewokName :(NSString*)module{
    if(!self.myDebugParams[module].showLog || ![self verifyCaller:framewokName :module])return NO;
    return YES;
}

-(BOOL)canSaveLog:(NSString*)framewokName :(NSString*)module{
    if(self.myDebugParams[module].saveLog || ![self verifyCaller:framewokName :module])return NO;
    return YES;
}

-(BOOL)canSaveFile:(NSString*)framewokName :(NSString*)module{
    if(self.myDebugParams[module].saveFile || ![self verifyCaller:framewokName :module])return NO;
    return YES;
}

#pragma mark - tools
-(void)createFolder:(NSString *)path{
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) return;
    [[NSFileManager defaultManager] createDirectoryAtPath:path 
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}

-(NSString*)getNowTime:(NSString*)format{
    // yyyyMMdd HHmmssSSS
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:today];
}

-(NSString*_Nullable)prettyPrintedJSON:(id)json{
    if(![json isKindOfClass:[NSDictionary class]] || ![json isKindOfClass:[NSArray class]]){
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - Core method
-(void)showLog:(NSString*)msg level:(LoggerLevel)level{
    @try {
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSDictionary<NSString*, NSString*> *callerInfo = [self callerParse:sourceString];
        
        NSString *outputMsg = [msg stringByAppendingFormat:@"[%@] %@", LoggerLevelStr(level), msg];
        if([self canShowLog:callerInfo[@"framework"] :callerInfo[@"class"]]){
            if(self.loggerLevel>=level){
                NSLog(@"%@", outputMsg);
                [self showLogOnView:outputMsg];
            }
        }
        
        if([self canSaveLog:callerInfo[@"framework"] :callerInfo[@"class"]]){
            [self saveLog:outputMsg];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

-(void)saveLog:(NSString*)msg{
    @try {
        NSString *logPath = [[NSString alloc] initWithString:self.debugRoot];
        logPath = [logPath stringByAppendingPathComponent:@"log.txt"];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:logPath]){
            [[NSData data] writeToFile:logPath atomically:YES];
                
            NSString *outputMsg = [NSString stringWithFormat:@"[%@] 開始寫入r\n", [self getNowTime:@"yyyy-MM-dd HH:mm:ss.SSS"]];
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            [handle writeData:[outputMsg dataUsingEncoding:NSUTF8StringEncoding]];
            [handle closeFile];
            
        }
        
        NSString *outputMsg = [NSString stringWithFormat:@"[%@] %@\r\n", [self getNowTime:@"yyyy-MM-dd HH:mm:ss.SSS"], msg];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        [handle writeData:[outputMsg dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    
}

-(void)saveJSON:(id)json filename:(NSString*)filename foldername:(NSString* _Nullable)foldername{
    @try {
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSDictionary<NSString*, NSString*> *callerInfo = [self callerParse:sourceString];
        
        if([self canSaveFile:callerInfo[@"framework"] :callerInfo[@"class"]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
            [self saveFile:data filename:filename extension:@"json" foldername:foldername];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

-(void)saveJPG:(UIImage*)img filename:(NSString*)filename foldername:(NSString* _Nullable)foldername{
    @try {
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSDictionary<NSString*, NSString*> *callerInfo = [self callerParse:sourceString];
        
        if([self canSaveFile:callerInfo[@"framework"] :callerInfo[@"class"]]){
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            [self saveFile:data filename:filename extension:@"jpg" foldername:foldername];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

-(void)saveFile:(NSString*)filename
      extension:(NSString*)extension
     foldername:(NSString* _Nullable)foldername
     preprocess:(NSData*(^)(void))preprocess{
    @try {
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSDictionary<NSString*, NSString*> *callerInfo = [self callerParse:sourceString];
        
        if([self canSaveFile:callerInfo[@"framework"] :callerInfo[@"class"]]){
            if(preprocess){
                NSData *data = preprocess();
                [self saveFile:data filename:filename extension:extension foldername:foldername];
            }
        }
    }@catch (NSException *exception){
        NSLog(@"exception: %@", exception);
    }
    
}

-(void)saveFile:(NSData*)data filename:(NSString*)filename extension:(NSString*)extension foldername:(NSString* _Nullable)foldername{
    @try {
        NSString *filepath = [[NSString alloc] initWithString:self.debugRoot];
        if(foldername && ![foldername isEqualToString:@""]){
            filepath = [filepath stringByAppendingPathComponent:foldername];
        }
        filepath = [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", filename, extension]];
        
        [data writeToFile:filepath atomically:YES];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

@end
