//
//  MyDebugView.m
//  MyTools
//
//  Created by Shen on 2024/8/24.
//

#import "MyDebugView.h"
#import "MyDebugMonitor.h"
#import <UIKit/UIKit.h>

@interface MyDebugView()
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIView *showView;
@property (strong, nonatomic) UILabel *debugStatus;
@property (strong, nonatomic) UIButton *debugBtn;
@property (strong, nonatomic) UITextView *debugView;
@property (strong, nonatomic) NSTimer *monitorTimer;

@end
@implementation MyDebugView

-(instancetype)init{
    self = [super init];
    
    if(self){
        [self initDebugView];
    }
    
    return self;
}

#pragma mark - debugView
-(UIViewController*)findTopViewController{
    UIWindow *keyWindow;
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
        if(windowScene.activationState == UISceneActivationStateForegroundActive){
            for(UIWindow *window in windowScene.windows){
                keyWindow = window;
                break;
            }
        }
    }
    if(keyWindow == nil){
        return nil;
    }
    
    UIViewController *topController = keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(void)initDebugView{
    self.topViewController = [self findTopViewController];
    CGRect frame = self.topViewController.view.frame;
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height*0.65-20, frame.size.width, frame.size.height*0.35)];
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.hidden = NO;
    [self.topViewController.view addSubview:self.showView];
    
    self.debugStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.showView.frame.size.width, 18)];
    self.debugStatus.font = [UIFont systemFontOfSize:18];
    self.debugStatus.backgroundColor = [UIColor blackColor];
    self.debugStatus.textColor = [UIColor greenColor];
    self.debugStatus.text = @"";
    [self.showView addSubview:self.debugStatus];
    
    
    self.debugView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, self.showView.frame.size.width, self.showView.frame.size.height-20)];
    self.debugView.backgroundColor = [UIColor blackColor];
    self.debugView.textColor = [UIColor greenColor];
    self.debugView.font = [UIFont systemFontOfSize:20];
    self.debugView.editable = NO;
    self.debugView.selectable = NO;
    self.debugView.text = @"";
    [self.showView addSubview:self.debugView];
    
    
    self.debugBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.debugBtn.frame = CGRectMake(0, self.showView.frame.origin.y-50, 50, 50);
    self.debugBtn.backgroundColor = [UIColor redColor];
    self.debugBtn.clipsToBounds = YES;
    self.debugBtn.layer.cornerRadius = 50*0.5;
    [self.debugBtn addTarget:self action:@selector(debugBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topViewController.view addSubview:self.debugBtn];
    
    self.monitorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateMonitorInfo) userInfo:nil repeats:YES];
}

-(void)checktTopViewController{
    if(self.topViewController == nil || ![self.topViewController isEqual:[self findTopViewController]]){
        if(self.debugStatus){
            [self.debugStatus removeFromSuperview];
            self.debugStatus = nil;
        }
        if(self.debugView){
            [self.debugView removeFromSuperview];
            self.debugView = nil;
        }
        if(self.showView){
            [self.showView removeFromSuperview];
            self.showView = nil;
        }
        if(self.debugBtn){
            [self.debugBtn removeFromSuperview];
            self.debugBtn = nil;
        }
        if(self.monitorTimer){
            [self.monitorTimer invalidate];
            self.monitorTimer = nil;
        }
        [self initDebugView];
    }
}

-(void)debugBtnClick{
    self.showView.hidden = !self.showView.hidden;
}

-(void)showLogOnView:(NSString*)msg{
    if(self.debugView == nil) return;
    [self checktTopViewController];
    
    self.debugView.text = [self.debugView.text stringByAppendingFormat:@"%@\r\n",msg];
    if (self.debugView.text.length > 0 ){
        NSRange bottom = NSMakeRange(self.debugView.text.length - 1, 1);
        [self.debugView scrollRangeToVisible:bottom];
    }
}

-(void)updateMonitorInfo{
    if(self.debugStatus == nil) return;
    
    unsigned int appCPUUsage = [MyDebugMonitor APPCPUUsage];
    unsigned long memoryUsage = [MyDebugMonitor MemoryUsage];
    self.debugStatus.text = [NSString stringWithFormat:@"CPU:%u%%, memory:%luMB", appCPUUsage, memoryUsage/(1024*1024)];
    
}

@end
