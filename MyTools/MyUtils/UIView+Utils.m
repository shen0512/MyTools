//
//  UIView+Utils.m
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)
- (CGRect)statusBarFrameViewRect{
    if (@available(iOS 13.0, *)){
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        
        return firstWindow.windowScene.statusBarManager.statusBarFrame;
    }else{
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGRect statusBarWindowRect = [self.window convertRect:statusBarFrame fromWindow: nil];
        CGRect statusBarViewRect = [self convertRect:statusBarWindowRect fromView: nil];
        
        return statusBarViewRect;
    }
}

@end
