# MyFile

## ```Overview```
檔案處理相關

## ```Notice```
1. import <MyTools/MyFile.h>

## ```Static Method```
|Method|Description|
|---|---|
|[+ (NSString*)getUUID](#getUUID)|取得 UUID|
|[+ (NSString*)getDocumentPath](#getDocumentPath)|取得 Document 路徑|
|[+ (NSString*)getTemporaryDirectory](#getTemporaryDirectory)|取得 Temporary 路徑|
|[+ (void)createFolder:(NSString *)path](#createFolder)|建立資料夾|
|[+ (NSArray*)loadJson:(NSString*)path](#loadJson)|載入 json 資料|
|[+ (void)writeJson:(NSString*)path data:(id)data replace:(BOOL)replace](#writeJson)|寫入 json 資料|
|[+ (NSArray*)loadText:(NSString*)path](#loadText)|載入 txt 資料|
|[+ (void)writeText:(NSString*)path data:(id)data replace:(BOOL)replace](#writeText)|寫入 txt 資料|

### getUUID
+ (NSString*)getUUID

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *UUID = [MyFile getUUID];
    NSLog(@"UUID: %@", UUID);
}

@end
```

### getDocumentPath
+ (NSString*)getDocumentPath

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    NSLog(@"path: %@", path);
}

@end
```

### getTemporaryDirectory
+ (NSString*)getTemporaryDirectory

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getTemporaryDirectory];
    NSLog(@"path: %@", path);
}

@end
```

### createFolder
+ (void)createFolder:(NSString *)path

|Param|Type|Description|
|---|---|---|
|path|NSString|資料夾路徑|

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    [MyFile createFolder:[path stringByAppendingPathComponent:@"testFolder"]];
}

@end
```

### loadJson
+ (NSArray*)loadJson:(NSString*)path

|Param|Type|Description|
|---|---|---|
|path|NSString|檔案路徑|

|Return Type|Description|
|---|---|
|NSArray|json 資料|

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    NSArray *json = [MyFile loadJson:[path stringByAppendingPathComponent:@"test.json"]];
    NSLog(@"json: %@", json);
}

@end
```

### writeJson
+ (void)writeJson:(NSString*)path data:(id)data replace:(BOOL)replace

|Param|Type|Description|
|---|---|---|
|path|NSString|檔案路徑|
|data|NSArray or NSArray[NSDictionary]|json 資料|
|replace|BOOL|取代相同檔名的檔案|

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    
    // write dictionary
    NSDictionary *dic = @{@"test1":@"1"};
    [MyFile writeJson:[path stringByAppendingPathComponent:@"test.json"] :dic :YES];
    
    // write NSArray
    NSArray *array = @[@{@"test2":@"2"}];
    [MyFile writeJson:[path stringByAppendingPathComponent:@"test2.json"] :array :YES];
}

@end
```

### loadText
+ (NSArray*)loadText:(NSString*)path

|Param|Type|Description|
|---|---|---|
|path|NSString|檔案路徑|

|Return Type|Description|
|---|---|
|NSArray|字串資料|

#### ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    
    NSArray *loadStr = [MyFile loadText:[path stringByAppendingPathComponent:@"test.txt"]];
    NSLog(@"str: %@", loadStr);
}

@end
```

### writeText
+ (void)writeText:(NSString*)path data:(id)data replace:(BOOL)replace

|Param|Type|Description|
|---|---|---|
|path|NSString|json 路徑|
|data|NSString or NSArray[NSString]|資料|
|replace|BOOL|取代相同檔名的檔案|

#### ```Example```
```objectivec=
//
//  ViewController.m
//  MyTest
//
//  Created by Shen on 2022/6/26.
//

#import "ViewController.h"
#import <MyTools/MyFile.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [MyFile getDocumentPath];
    
    // write NSString
    NSString *str = @"This is a test file.";
    [MyFile writeText:[path stringByAppendingPathComponent:@"test.txt"] data:str replace:YES];
    
    // write NSArray(NSString)
    NSArray *strArray = @[@"This is a test file2."];
    [MyFile writeText:[path stringByAppendingPathComponent:@"test2.txt"] data:strArray replace:YES];
}

@end
```
