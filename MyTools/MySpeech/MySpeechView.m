//
//  MySpeechView.m
//  MyTools
//
//  Created by Shen on 2023/2/25.
//

#import "MySpeechView.h"
#import "MySpeech.h"

@interface MySpeechView()<MySpeechDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *startBtn;
@property (strong, nonatomic) UIButton *stopBtn;

@property (strong, nonatomic) MySpeech *mySpeech;

@end

@implementation MySpeechView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        CGFloat statusBarH = [self statusBarFrameViewRect].size.height;
        CGFloat frameW = frame.size.width;
        CGFloat frameH = frame.size.height;
        self.textView = [UITextView new];
        self.textView.text = @"";
        [self.textView setFont:[UIFont systemFontOfSize:25]];
        self.textView.scrollEnabled = YES;
        self.textView.editable = NO;
        self.textView.frame = CGRectMake(0, statusBarH+5, frameW, frameH*0.25);
        [self addSubview:self.textView];
        
        self.startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
        self.startBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        self.startBtn.backgroundColor = [UIColor blueColor];
        [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.startBtn.layer.cornerRadius = 5;
        self.startBtn.clipsToBounds = YES;
        [self.startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        self.startBtn.frame = CGRectMake(frameW*0.5-100-10,
                                         self.textView.frame.size.height+self.textView.frame.origin.y+10,
                                         100,
                                         40);
        [self addSubview:self.startBtn];

        self.stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
        self.stopBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        self.stopBtn.backgroundColor = [UIColor redColor];
        [self.stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.stopBtn.layer.cornerRadius = 5;
        self.stopBtn.clipsToBounds = YES;
        self.stopBtn.frame = CGRectMake(frameW*0.5+10,
                                        self.textView.frame.size.height+self.textView.frame.origin.y+10,
                                        100,
                                        40);
        [self.stopBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stopBtn];
        
        self.mySpeech = [MySpeech new];
        self.mySpeech.delegate = self;
    }
    
    return self;
}
#pragma mark - MySpeechDelegate
-(void)getResult:(NSString *)result{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = result;
    });
}

#pragma mark - actions
-(void)startAction{
    self.textView.text = @"";
    [self.mySpeech startListening];
}

-(void)stopAction{
    [self.mySpeech stopListening];
}

#pragma mark - tools
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
