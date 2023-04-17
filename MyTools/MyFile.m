//
//  MyFile.m
//  MyTools
//
//  Created by Shen on 2022/7/16.
//

#import "MyFile.h"

@implementation MyFile

+ (NSString*)getUUID{
    /**
     @brief get uuid
     */
    return [[NSUUID UUID] UUIDString];
}
+ (NSString*)getDocumentPath{
    /**
     @brief get document path
     */
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentsPath firstObject];
    
    return documentPath;
}
+ (NSString*)getTemporaryDirectory{
    return NSTemporaryDirectory();
}
+ (void)createFolder:(NSString *)path{
    /**
     @brief create folder
     */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        NSLog(@"folder exist.");
        return;
    }
    
    NSError *error;
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(error){
        NSLog(@"error: %@", error);
    }
}
+ (NSArray*)loadJson:(NSString*)path{
    /**
     @brief load json file
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSLog(@"file not founded");
        return nil;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&error];
    if(error){
        NSLog(@"error: %@",error);
    }
    return jsonArray;
}
+ (void)writeJson:(NSString*)path data:(id)data replace:(BOOL)replace{
    /**
     @brief write a json file
     @param path file output path
     @param data (only support NSDictionary or NSArray)
     @param replace replace the file when the file exist
     */
    
    if(!([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]])){
        NSLog(@"The type of data only support NSDictionary or NSArray.");
        
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path] && !replace){
        NSLog(@"file exit.");
        return;
    }
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:kNilOptions
                                                         error:&error];
    
    if(error){
        NSLog(@"error: %@", error);
        return;
    }
    
    [jsonData writeToFile:path atomically:YES];
    
}
+ (NSArray*)loadText:(NSString*)path{
    NSError *error;
    NSArray *fileData = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
    
    if(error){
        NSLog(@"error: %@", error);
        return nil;
    }else{
        return fileData;
    }
}
+(void)writeText:(NSString*)path data:(id)data replace:(BOOL)replace{
    
    if(!([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSArray class]])){
        NSLog(@"The type of data only support NSString or NSArray.");
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path] && !replace){
        NSLog(@"file exit.");
        return;
    }
    
    NSString *str=@"";
    if([data isKindOfClass:[NSArray class]]){
        str = [data componentsJoinedByString:@"\n"];
    }else{
        str = data;
    }
    
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
