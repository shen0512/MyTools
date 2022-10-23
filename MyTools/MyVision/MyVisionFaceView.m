//
//  MyVisionFaceView.m
//  MyTools
//
//  Created by Shen on 2022/10/23.
//

#import "MyVisionFaceView.h"
#import "MyDrawUtils.h"
#import "MyCamera.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"
#import "MyVisionFace.h"

@interface MyVisionFaceView()<MyCameraDelegate>
@property (nonatomic) MyCamera *myCamera;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawView;

@property (strong, nonatomic) UIButton *detectTypeBtn;
@property (strong, nonatomic) UILabel *detectTypeLabel;
@property (nonatomic) NSString *detectType;

@property (strong, nonatomic) UIButton *changeLensBtn;

@property (atomic) BOOL isDetect;
@end

@implementation MyVisionFaceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        self.drawView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.drawView];
        
        NSString *detectTypeStr = @"change detect type";
        self.detectTypeBtn = [UIButton new];
        CGFloat detectTypeBtnW = [detectTypeStr stringWidth:[self.detectTypeBtn.titleLabel font]];
        CGFloat detectTypeBtnH = [detectTypeStr stringHeight:[self.detectTypeBtn.titleLabel font]];
        [self.detectTypeBtn setTitle:detectTypeStr forState:UIControlStateNormal];
        self.detectTypeBtn.titleLabel.textColor = [UIColor blackColor];
        self.detectTypeBtn.backgroundColor = [UIColor blueColor];
        self.detectTypeBtn.frame = CGRectMake(10, [self statusBarFrameViewRect].size.height, detectTypeBtnW+20, detectTypeBtnH+20);
        self.detectTypeBtn.layer.cornerRadius = 5;
        self.detectTypeBtn.clipsToBounds = YES;
        [self.detectTypeBtn addTarget:self action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        self.detectTypeBtn.tag = 0;
        [self addSubview:self.detectTypeBtn];
        
        self.detectType = @"face";
        
        self.detectTypeLabel = [UILabel new];
        self.detectTypeLabel.text = self.detectType;
        CGFloat detectTypeLabelW = [self.detectType stringWidth:[self.detectTypeLabel font]];
        CGFloat detectTypeLabelH = [self.detectType stringHeight:[self.detectTypeLabel font]];
        
        self.detectTypeLabel.frame = CGRectMake(self.detectTypeBtn.frame.origin.x+self.detectTypeBtn.frame.size.width+5,
                                                self.detectTypeBtn.frame.origin.y,
                                                detectTypeLabelW+20,
                                                detectTypeLabelH+20);
        self.detectTypeLabel.textColor = [UIColor blackColor];
        self.detectTypeLabel.backgroundColor = [UIColor whiteColor];
        self.detectTypeLabel.textAlignment = NSTextAlignmentCenter;
        self.detectTypeLabel.layer.cornerRadius = 5;
        self.detectTypeLabel.clipsToBounds = YES;
        [self addSubview:self.detectTypeLabel];
        
        self.changeLensBtn = [UIButton new];
        NSString *changeLensStr = @"change lens";
        [self.changeLensBtn setTitle:changeLensStr forState:UIControlStateNormal];
        CGFloat changeLensBtnW = [changeLensStr stringWidth:self.changeLensBtn.titleLabel.font];
        CGFloat changeLensBtnH = [changeLensStr stringHeight:self.changeLensBtn.titleLabel.font];
        self.changeLensBtn.frame = CGRectMake(10,
                                              frame.size.height-changeLensBtnH-10-20,
                                              changeLensBtnW+20,
                                              changeLensBtnH+20);
        self.changeLensBtn.layer.cornerRadius = 5;
        self.changeLensBtn.clipsToBounds = YES;
        self.changeLensBtn.backgroundColor = [UIColor redColor];
        self.changeLensBtn.titleLabel.textColor = [UIColor blackColor];
        self.changeLensBtn.tag = 1;
        [self.changeLensBtn addTarget:self action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeLensBtn];
        
        [self.myCamera startCapture];
    }
    
    return self;
}

#pragma mark MyCamera - delegate
- (void)getFrame:(UIImage *)frame{
    self.imageView.image = frame;
    
    if(self.isDetect)return;
    self.isDetect = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.drawView.image = nil;
    });
    
    if([self.detectType isEqualToString:@"face"]){
        [MyVisionFace detectFace:frame results:^(NSArray * _Nonnull results) {
            UIImage *canvas = [MyDrawUtils createCanvas:frame.size.width :frame.size.height];
            for(int i=0; i<[results count]; i++){
                CGRect tmpBbox = [results[i] CGRectValue];
                canvas = [MyDrawUtils drawRect:canvas :tmpBbox];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.drawView.image = canvas;
                self.isDetect = NO;
            });
            
        }];
    }else if ([self.detectType isEqualToString:@"face+landmark"]){
        [MyVisionFace detectFaceWithLandmark:frame results:^(NSDictionary * _Nonnull results) {
            UIImage *canvas = [MyDrawUtils createCanvas:frame.size.width :frame.size.height];
            
            NSArray *bboxes = results[@"bboxes"];
            NSArray *landmarks = results[@"landmarks"];
            for(int i=0; i<[bboxes count]; i++){
                CGRect tmpBbox = [bboxes[i] CGRectValue];
                canvas = [MyDrawUtils drawRect:canvas :tmpBbox];
                
                NSArray *tmpLandmark = landmarks[i];
                canvas = [MyDrawUtils drawPointByPoints:canvas :tmpLandmark];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.drawView.image = canvas;
                self.isDetect = NO;
            });
            
        }];
    }
    
}

#pragma mark button listener
- (void)btnUpInside:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 0){
        if([self.detectType isEqualToString:@"face"]){
            self.detectType = @"face+landmark";
        }else if([self.detectType isEqualToString:@"face+landmark"]){
            self.detectType = @"face";
        }
        
        self.detectTypeLabel.text = self.detectType;
        CGFloat detectTypeLabelW = [self.detectType stringWidth:[self.detectTypeLabel font]];
        CGFloat detectTypeLabelH = [self.detectType stringHeight:[self.detectTypeLabel font]];
        self.detectTypeLabel.frame = CGRectMake(self.detectTypeBtn.frame.origin.x+self.detectTypeBtn.frame.size.width+5,
                                                self.detectTypeBtn.frame.origin.y,
                                                detectTypeLabelW+20,
                                                detectTypeLabelH+20);
    }else if(btn.tag == 1){
        [self.myCamera changeLens];
        
        if(self.myCamera.isFrontLens){
            self.imageView.transform = CGAffineTransformMakeScale(-1, 1);
            self.drawView.transform = CGAffineTransformMakeScale(-1, 1);
        }else{
            self.imageView.transform = CGAffineTransformMakeScale(1, 1);
            self.drawView.transform = CGAffineTransformMakeScale(1, 1);
        }
    }
    
}

@end
