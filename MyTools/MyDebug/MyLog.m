//
//  MyLog.m
//  MyTools
//
//  Created by Shen on 2023/1/8.
//

#import "MyLog.h"

@implementation MyLog
+ (void)redirectLogToFile{
    NSLog(@"redirect console to file");
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [allPaths objectAtIndex:0];
    NSString *logRootPath = [documentPath stringByAppendingPathComponent:@"consoleLog"];
    
    // check logRoot directory
    if(![[NSFileManager defaultManager] fileExistsAtPath:logRootPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:logRootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }else{
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logRootPath error:nil];
        if([contents count] > 1){
            // only keep log for one day
            [[NSFileManager defaultManager] removeItemAtPath:logRootPath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:logRootPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    // create log file path
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *date = [dateFormatter stringFromDate:today];
    NSString *logDirectory = [logRootPath stringByAppendingPathComponent:date];
    if(![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmmssSSS"];
    NSString *time = [timeFormatter stringFromDate:today];
    NSString *logPath = [logDirectory stringByAppendingPathComponent:[time stringByAppendingString:@".txt"]];
    NSLog(@"log file path at: %@", logPath);
    
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
@end
