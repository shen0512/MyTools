//
//  MyVisionRectangleView.m
//  MyTools
//
//  Created by Shen on 2022/10/29.
//

#import "MyVisionRectangleView.h"
#import "MyCamera.h"
#import "MyVisionRectangle.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"
#import "MyVisionUtils.h"

#import "MyDrawUtils.h"

@interface MyVisionRectangleView()<MyCameraDelegate>
@property (nonatomic) MyCamera *myCamera;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawView;
@property (strong, nonatomic) UIImageView *cropView;
@property (nonatomic) BOOL isDetectDone;

@property (strong, nonatomic) UIButton *detectTypeBtn;
@property (strong, nonatomic) UIButton *cropBtn;
@property (strong, nonatomic) UIButton *okBtn;
@property (strong, nonatomic) UILabel *detectTypeLabel;
@property (nonatomic) NSString *detectType;
@property (nonatomic) BOOL isCrop;

@end

@implementation MyVisionRectangleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        self.drawView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.drawView];
        
        self.isDetectDone = YES;
        
        //
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
        
        self.detectType = @"detect";
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
        
        NSString *cropStr = @"crop";
        self.cropBtn = [UIButton new];
        CGFloat cropStrW = [cropStr stringWidth:self.cropBtn.titleLabel.font];
        CGFloat cropStrH = [cropStr stringHeight:self.cropBtn.titleLabel.font];
        
        [self.cropBtn setTitle:@"crop" forState:UIControlStateNormal];
        self.cropBtn.frame = CGRectMake((self.frame.size.width-cropStrW-40)*0.5,
                                        self.frame.size.height-cropStrH-40,
                                        cropStrW+40,
                                        cropStrH+20);
        self.cropBtn.backgroundColor = [UIColor blueColor];
        self.cropBtn.titleLabel.textColor = [UIColor whiteColor];
        self.cropBtn.clipsToBounds = YES;
        self.cropBtn.layer.cornerRadius = 5;
        self.cropBtn.hidden = YES;
        self.cropBtn.tag = 1;
        [self.cropBtn addTarget:self action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cropBtn];
        
        
        
        self.cropView = [[UIImageView alloc] initWithFrame:frame];
        self.cropView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cropView];
        self.cropView.hidden = YES;
        
        NSString *okStr = @"ok";
        self.okBtn = [UIButton new];
        CGFloat okStrW = [cropStr stringWidth:self.okBtn.titleLabel.font];
        CGFloat okStrH = [cropStr stringHeight:self.okBtn.titleLabel.font];
        
        [self.okBtn setTitle:okStr forState:UIControlStateNormal];
        self.okBtn.frame = CGRectMake((self.frame.size.width-okStrW-20)*0.5,
                                      self.frame.size.height-okStrH-40,
                                      okStrW+20,
                                      okStrH+20);
        self.okBtn.backgroundColor = [UIColor blueColor];
        self.okBtn.titleLabel.textColor = [UIColor whiteColor];
        self.okBtn.clipsToBounds = YES;
        self.okBtn.layer.cornerRadius = 5;
        self.okBtn.hidden = YES;
        self.okBtn.tag = 2;
        [self.okBtn addTarget:self action:@selector(btnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okBtn];
        
        
        [self.myCamera startCapture];
    }
    
    return self;
}

#pragma mark MyCamera - delegate
- (void)getFrame:(UIImage *)frame{
    
    self.imageView.image = frame;
    
    if(!self.isDetectDone)return;
    self.isDetectDone = NO;
    self.drawView.image = nil;
    
    [MyVisionRectangle detect:frame results:^(NSArray * _Nullable results) {
        if(results){
            if([self.detectType isEqualToString:@"crop"]){
                [self drawResult:frame.size.width height:frame.size.height result:[results firstObject] canvas:^(UIImage *canvas) {
                    self.drawView.image = canvas;
                    self.isDetectDone = YES;
                }];
            }else{
                [self drawResults:frame.size.width height:frame.size.height results:results canvas:^(UIImage *canvas) {
                    self.drawView.image = canvas;
                    self.isDetectDone = YES;
                }];
            }
            
            if(self.isCrop){
                [self.myCamera stopCapture];
                UIImage *cropFrame = [MyVisionUtils perspectiveCorrection:frame points:results[0][@"points"]];
                self.cropView.image = cropFrame;
            }
            
        }else{
            self.isDetectDone = YES;
        }
    }];
    
}

#pragma mark button listener
- (void)btnUpInside:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 0){
        self.cropView.image = nil;
        self.cropView.hidden = YES;
        
        if([self.detectType isEqualToString:@"detect"]){
            self.detectType = @"crop";
            self.cropBtn.hidden = NO;
        }else if([self.detectType isEqualToString:@"crop"]){
            self.detectType = @"detect";
            self.cropBtn.hidden = YES;
        }
        
        self.detectTypeLabel.text = self.detectType;
        CGFloat detectTypeLabelW = [self.detectType stringWidth:[self.detectTypeLabel font]];
        CGFloat detectTypeLabelH = [self.detectType stringHeight:[self.detectTypeLabel font]];
        self.detectTypeLabel.frame = CGRectMake(self.detectTypeBtn.frame.origin.x+self.detectTypeBtn.frame.size.width+5,
                                                self.detectTypeBtn.frame.origin.y,
                                                detectTypeLabelW+20,
                                                detectTypeLabelH+20);
    }else if(btn.tag == 1){
        self.cropView.hidden = NO;
        self.okBtn.hidden = NO;
        self.isCrop = YES;
        
    }else if(btn.tag == 2){
        self.okBtn.hidden = YES;
        self.isDetectDone = YES;
        self.isCrop = NO;
        self.cropView.image = nil;
        self.cropView.hidden = YES;
        
        [self.myCamera startCapture];
        
    }
    
}

#pragma mark Draw result
- (void)drawResult:(CGFloat)width height:(CGFloat)height result:(NSDictionary*)result canvas:(void(^)(UIImage *canvas))canvas{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // bbox
    CGRect bbox = [result[@"bbox"] CGRectValue];
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(context, 5);
    CGContextAddRect(context, bbox);
    CGContextDrawPath(context, kCGPathStroke);
    
    // corner
    NSDictionary *points = result[@"points"];
    for(NSString *key in points){
        CGPoint point = [points[key] CGPointValue];
        
        [[UIColor redColor] setStroke];
        CGContextSetLineWidth(context, 10);
        CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    
    UIImage *drawResult=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    canvas(drawResult);
}

- (void)drawResults:(CGFloat)width height:(CGFloat)height results:(NSArray*)results canvas:(void(^)(UIImage *canvas))canvas{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(NSDictionary *result in results){
        // bbox
        CGRect bbox = [result[@"bbox"] CGRectValue];
        [[UIColor greenColor] setStroke];
        CGContextSetLineWidth(context, 5);
        CGContextAddRect(context, bbox);
        CGContextDrawPath(context, kCGPathStroke);
        
        // corner
        NSDictionary *points = result[@"points"];
        for(NSString *key in points){
            CGPoint point = [points[key] CGPointValue];
            
            [[UIColor redColor] setStroke];
            CGContextSetLineWidth(context, 10);
            CGContextAddRect(context, CGRectMake(point.x-2, point.y-2, 4, 4));
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        
    }
    
    UIImage *drawResult=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    canvas(drawResult);
}
@end
