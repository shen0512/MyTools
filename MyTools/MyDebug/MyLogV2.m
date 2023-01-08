//
//  MyLogV2.m
//  MyTools
//
//  Created by Shen on 2023/1/8.
//

#import "MyLogV2.h"
@interface MyLogV2()
void appendToLogFile(NSString *msg);
@end

const char *logPath;
@implementation MyLogV2
void _Log(const char *file, int lineNumber, const char *funcName, NSString *format,...){
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *consoleMsg = [NSString stringWithFormat:@"%@ %@ [line:%d] %@", dateString, [NSString stringWithUTF8String:funcName], lineNumber, msg];
    fprintf(stderr, "%s", [consoleMsg UTF8String]);
    appendToFile(consoleMsg);
}

void appendToFile(NSString *msg){
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *logRootPath = [documentPath stringByAppendingPathComponent:@"consoleLog"];
    if(logPath == NULL){
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
        NSString *logDirPath = [logRootPath stringByAppendingPathComponent:date];
        if(![[NSFileManager defaultManager] fileExistsAtPath:logDirPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:logDirPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HHmmssSSS"];
        NSString *time = [timeFormatter stringFromDate:today];
        logPath = [[logDirPath stringByAppendingPathComponent:[time stringByAppendingString:@".txt"]] UTF8String];
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:logPath]]){
            fprintf(stderr,"log file path at: %s\n",logPath);
            [[NSData data] writeToFile:[NSString stringWithUTF8String:logPath] atomically:YES];
        }
        
    }
    
    // save(append) console log to the file
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithUTF8String:logPath]];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

@end
