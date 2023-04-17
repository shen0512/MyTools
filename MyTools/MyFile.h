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
+ (NSString*)getTemporaryDirectory;
+ (void)createFolder:(NSString *)path;
+ (NSArray*)loadJson:(NSString*)path;
+ (void)writeJson:(NSString*)path data:(id)data replace:(BOOL)replace;
+ (NSArray*)loadText:(NSString*)path;
+ (void)writeText:(NSString*)path data:(id)data replace:(BOOL)replace;
@end

NS_ASSUME_NONNULL_END
