//
//  MyFile.h
//  MyTools
//
//  Created by Shen on 2022/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyFile : NSObject

+ (NSString*)getUUID;
+ (NSString*)getDocumentPath;
+ (void)createFolder:(NSString *)path;
+ (NSArray*)loadJson:(NSString*)path;
+ (void)writeJson:(NSString*)path :(id) data :(BOOL)replace;
+ (void)writeJsonDic:(NSString*)path :(NSDictionary*) data :(BOOL)replace;

@end

NS_ASSUME_NONNULL_END
