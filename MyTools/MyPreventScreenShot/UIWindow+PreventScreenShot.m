//
//  UIWindow+PreventScreenShot.m
//  MyTools
//
//  Created by Shen on 2022/12/3.
//

#import "UIWindow+PreventScreenShot.h"

@implementation UIWindow (PreventScreenShot)

- (void)preventScreenShot{
    if(@available(iOS 13.0, *)){
        UITextField *textField = [UITextField new];
        textField.secureTextEntry = YES;
        [self addSubview:textField];
        [[textField.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[textField.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [self.layer.superlayer addSublayer:textField.layer];
        [textField.layer.sublayers.firstObject addSublayer:self.layer];
        
    }else{
        NSLog(@"最低需求為: iOS 15");
    }
}

@end
