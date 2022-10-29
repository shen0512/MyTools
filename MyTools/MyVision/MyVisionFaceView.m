//
//  MyVisionFaceView.m
//  MyTools
//
//  Created by Shen on 2022/10/23.
//

#import "MyVisionFaceView.h"
#import "MyVisionFace.h"
#import "MyCamera.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"


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
        [MyVisionFace detect:frame results:^(NSArray * _Nonnull results) {
            UIImage *canvas = [self drawBboxes:frame.size.width height:frame.size.height bboxes:results];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.drawView.image = canvas;
                self.isDetect = NO;
            });
            
        }];
    }else if ([self.detectType isEqualToString:@"face+landmark"]){
        [MyVisionFace detectWithLandmark:frame results:^(NSDictionary * _Nonnull results) {
            
            NSArray *bboxes = results[@"bboxes"];
            NSArray *landmarks = results[@"landmarks"];
            
            UIImage *canvas = [self drawBboxesWithLandmark:frame.size.width height:frame.size.height bboxes:bboxes landmarks:landmarks];
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

#pragma mark Draw result
- (UIImage*)drawBboxes:(CGFloat)width height:(CGFloat)height bboxes:(NSArray*)bboxes{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(int i=0; i<[bboxes count]; i++){
        [[UIColor greenColor] setStroke];
        CGContextSetLineWidth(context, 5);
        CGContextAddRect(context, [bboxes[i]CGRectValue]);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage*)drawBboxesWithLandmark:(CGFloat)width height:(CGFloat)height bboxes:(NSArray*)bboxes landmarks:(NSArray*)landmarks{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(int i=0; i<[bboxes count]; i++){
        [[UIColor greenColor] setStroke];
        CGContextSetLineWidth(context, 5);
        CGContextAddRect(context, [bboxes[i]CGRectValue]);
        CGContextDrawPath(context, kCGPathStroke);
        
        for(int j=0; j<[landmarks[i] count]; j++){
            [[UIColor redColor] setStroke];
            CGContextSetLineWidth(context, 10);
            CGPoint point = [landmarks[i][j] CGPointValue];
            CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        
    }
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


@end
