//
//  MyCameraView.m
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import "MyCameraView.h"
#import "MyCamera.h"
#import "NSString+Utils.h"
#import "UIView+Utils.h"

@interface MyCameraView()<MyCameraDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) MyCamera *myCamera;

@property (strong, nonatomic) UIButton *changeLensBtn;

@end

@implementation MyCameraView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        // view init
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        
        NSString *changeLensStr = @"鏡頭切換";
        self.changeLensBtn = [UIButton new];
        [self.changeLensBtn setTitle:changeLensStr forState:UIControlStateNormal];
        CGFloat changeLensStrW = [changeLensStr stringWidth:self.changeLensBtn.titleLabel.font];
        CGFloat changeLensStrH = [changeLensStr stringHeight:self.changeLensBtn.titleLabel.font];
        CGFloat statusBarH = [self statusBarFrameViewRect].size.height;
        self.changeLensBtn.frame = CGRectMake(10, statusBarH, changeLensStrW+10, changeLensStrH+10);
        self.changeLensBtn.backgroundColor = [UIColor blueColor];
        self.changeLensBtn.titleLabel.textColor = [UIColor blackColor];
        self.changeLensBtn.layer.cornerRadius = 5;
        self.changeLensBtn.clipsToBounds = YES;
        self.changeLensBtn.tag = 0;
        [self.changeLensBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
        [self.changeLensBtn addTarget:self action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.changeLensBtn addTarget:self action:@selector(btnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:self.changeLensBtn];
        
        // camera init
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        [self.myCamera startCapture];
    }
    
    return self;
}

#pragma mark MyCamera - delegte
- (void)getFrame:(UIImage*)frame{
    self.imageView.image = frame;

}

#pragma mark button listener
- (void)btnUpInside:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 0){
        [self changeLens];
    }
}

- (void)btnUpOutside:(id)sender{
    
}

- (void)btnDown:(id)sender{

}

#pragma mark functions
- (void)changeLens{
    [self.myCamera changeLens];
    
    if(self.myCamera.isFrontLens){
        self.imageView.transform = CGAffineTransformMakeScale(-1, 1);
        
    }else{
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    }
}

@end
