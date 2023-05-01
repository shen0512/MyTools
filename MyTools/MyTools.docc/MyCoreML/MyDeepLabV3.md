# MyDeepLabv3

## Overview
CoreML DeepLab

## Notice
1. import <MyTools/MyDeepLabv3.h>

## Instance Method
|Method|Description|
|---|---|
|[- (instancetype)init](#init)|初始化|
|[- (void)inference:(UIImage*)image result:(void(^)(MLMultiArray *result))result](#inference)|圖片推論|

### ```init```
\- (instancetype)init

### ```inference```
\- (void)inference:(UIImage*)image result:(void(^)(MLMultiArray *result))result

|Param|Type|Description|
|---|---|---|
|image|UIImage|輸入影像|
|result|(void(^)(MLMultiArray *result))|辨識後回傳 MLMultiArray|

#### Example
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import "MyDeepLabV3.h"

@interface ViewController()
@property (nonatomic) MyDeepLabV3 *myDeepLabV3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myDeepLabV3 = [MyDeepLabV3 new];
}

- (void)viewDidAppear:(BOOL)animated{
    UIImage *testImg = [UIImage imageNamed:@"test.jpg"];
    [self.myDeepLabV3 inference:testImg result:^(MLMultiArray * _Nonnull result) {
        // do something here
    }];
}
@end

```
