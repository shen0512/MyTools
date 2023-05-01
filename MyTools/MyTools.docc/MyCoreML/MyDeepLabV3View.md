# MyDeepLabv3View

## ```Overview```
CoreML DeepLab (UI版)，並依據不同類別進行著色

## ```Notice```
1. 加入 "Privacy - Camera Usage Description" 至 Info.plist
2. 加入 import <MyTools/MyDeepLabv3View.h>

## ```Example```
```objectivec=
//
//  ViewController.m

#import "ViewController.h"
#import <MyTools/MyDeepLabV3View.h>

@interface ViewController()
@property MyDeepLabV3View *myDeepLabV3View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myDeepLabV3View = [[MyDeepLabV3View alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.myDeepLabV3View];
}

@end

```

![](./MyDeepLabV3.png)
