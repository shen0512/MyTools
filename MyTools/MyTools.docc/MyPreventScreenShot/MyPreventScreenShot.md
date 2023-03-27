# MySpeech

## ```Overview```
透過UITextField的UITextFieldCanvasView達到防止螢幕截錄的功能

## ```Notice```
1. iOS13或以後的版本
2. import <MyTools/UIWindow+PreventScreenShot.h>


## ```Instance Method```
|Method|Description|
|---|---|
|- (void)preventScreenShot|防止螢幕截圖|

## ```Example```
```objectivec=
//  ViewController.m

#import "ViewController.h"
#import <MyTools/UIWindow+PreventScreenShot.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWindow *window;
    if (@available(iOS 13.0, *)){
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }else{
        window = [[UIApplication sharedApplication] keyWindow];
    }
    [window preventScreenShot];
}

@end

```
![](./MyPreventScreenShot.png)
