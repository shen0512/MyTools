# ```MySpeech```

## Overview
透過語音識別框架進行語音辨識

## Notice
1. 加入 "Privacy - Microphone Usage Description" 至 Info.plist
2. 加入 "Privacy - Speech Recognition Usage Description" 至 Info.plist
3. import <MyTools/MySpeech.h>
4. 添加 "MySpeechDelegate"

## Delegate Method
|Method|Description|
|---|---|
|[-(void)getResult:(NSString*)result](#getResult)|取得語音辨識結果|

### Detail
#### getResult
|Param|Type|Description|
|---|---|---|
|result|NSString|語音辨識結果|

## Instance Method
|Method|Description|
|---|---|
|startListening|開始監聽|
|stopListening|取消監聽|

## Example
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MySpeech.h>

@interface ViewController()<MySpeechDelegate>
@property (strong, nonatomic) MySpeech *speech;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.speech = [MySpeech new];
    self.speech.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.speech startListening];
}

-(void)getResult:(NSString *)result{
    NSLog(@"%@", result);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.speech stopListening];
}

@end

```
