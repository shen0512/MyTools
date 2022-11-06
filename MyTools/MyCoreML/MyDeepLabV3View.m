//
//  MyDeepLabV3View.m
//  MyTools
//
//  Created by Shen on 2022/11/5.
//

#import "MyDeepLabV3View.h"
#import "MyDeepLabV3.h"
#import "MyCamera.h"
#import "MyDeepLabV3.h"
#import <Vision/Vision.h>

@interface MyDeepLabV3View()<MyCameraDelegate>
@property (strong, nonatomic) MyCamera *myCamera;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawView;

@property (nonatomic) MyDeepLabV3 *myDeepLabV3;
@property (atomic) BOOL getNew;

@end

@implementation MyDeepLabV3View

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        self.drawView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.drawView];
        
        //
        self.myDeepLabV3 = [MyDeepLabV3 new];
        
        //
        self.getNew = YES;
        
        [self.myCamera startCapture];
    }
    
    return self;
}

#pragma mark MyCamera delegate
- (void)getFrame:(UIImage *)frame{
    self.imageView.image = frame;
    
    if(!self.getNew) return;
    self.drawView.image = nil;
    [self.myDeepLabV3 inference:frame result:^(MLMultiArray * _Nonnull result) {
        self.drawView.image = [self drawResults:frame.size.width height:frame.size.height segmentation:result];
    }];
    
    
}

#pragma mark draws
- (UIImage*)drawResults:(CGFloat)width height:(CGFloat)height segmentation:(MLMultiArray*)segmentation{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int *ptr = (int*)segmentation.dataPointer;
    int segW = [segmentation.shape[0] intValue];
    int segH = [segmentation.shape[1] intValue];
    for(int i=0; i<segH; i++){
        for(int j=0; j<segW; j++){
            int offset = [segmentation.strides[0] intValue]*i+[segmentation.strides[1] intValue]*j;
            int value = ptr[offset];
            
            CGFloat x = (j*1.0/segW)*width;
            CGFloat y = (i*1.0/segH)*height;
            CGFloat w = 1;
            CGFloat h = 1;
            
            if(i+1 < segH){
                h = 1.0/segH*height;
            }
            if(j+1 < segW){
                w = 1.0/segW*width;
            }
            UIColor *labelColor;
            if(value == 0){
                labelColor = [UIColor clearColor];
            }else{
                labelColor = [UIColor colorWithHue:value*1.0/20 saturation:1 brightness:1 alpha:0.5];
            }
            
            CGContextSetFillColorWithColor(context, [labelColor CGColor]);
            CGContextFillRect(context, CGRectMake(x, y, w, h));
        }
    }
    
    UIImage *drawResult=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return drawResult;
}

@end
