//
//  MyVisionBarcodeView.m
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import "MyVisionBarcodeView.h"
#import "MyCamera.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"
#import "MyVisionBarcode.h"
#import "MyDrawUtils.h"

@interface MyVisionBarcodeView()<MyCameraDelegate>
@property (nonatomic) MyCamera *myCamera;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawView;

@property (atomic) BOOL isDetectDone;

@property (strong, nonatomic) UILabel *infoLabel;
@property (nonatomic) CGFloat statusBarH;
@end

@implementation MyVisionBarcodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        self.drawView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.drawView];
        
        self.infoLabel = [UILabel new];
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.backgroundColor = [UIColor blackColor];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.layer.cornerRadius = 5;
        self.infoLabel.clipsToBounds = YES;
        [self addSubview:self.infoLabel];
        
        self.statusBarH = [self statusBarFrameViewRect].size.height;
        self.isDetectDone = YES;
        
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
    
    [MyVisionBarcode detectWithMaxConf:frame results:^(NSDictionary * _Nullable results) {
        self.drawView.image = nil;
        if(results){
            [self drawResult:frame.size.width height:frame.size.height results:results canvas:^(UIImage *canvas) {
                self.drawView.image = canvas;
                self.isDetectDone = YES;
            }];
        }else{
            self.isDetectDone = YES;
        }
        
        
    }];
    
}

#pragma mark Draw result
- (void)drawResult:(CGFloat)width height:(CGFloat)height results:(NSDictionary*)results canvas:(void(^)(UIImage *canvas))canvas{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(NSString *key in results){
        CGRect bbox = [results[key][@"bbox"] CGRectValue];
        
        // bbox
        [[UIColor greenColor] setStroke];
        CGContextSetLineWidth(context, 5);
        CGContextAddRect(context, bbox);
        CGContextDrawPath(context, kCGPathStroke);
        
        // text
        UIFont *font = [UIFont systemFontOfSize:50];
        CGFloat textW = [key stringWidth:font];
        CGFloat textH = [key stringHeight:font];
        
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextFillRect(context, CGRectMake(bbox.origin.x, bbox.origin.y-textH, textW, textH));
        
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        [key drawAtPoint:CGPointMake(bbox.origin.x, bbox.origin.y-textH) withAttributes:@{NSFontAttributeName:font}];
    }
    
    UIImage *drawResult=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    canvas(drawResult);
}

@end
