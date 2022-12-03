//
//  MyVisionPersonSegmentationView.m
//  MyTools
//
//  Created by Shen on 2022/12/3.
//

#import "MyVisionPersonSegmentationView.h"
#import "MyVisionPersonSegmentation.h"
#import "MyCamera.h"
@interface MyVisionPersonSegmentationView()<MyCameraDelegate>
@property (nonatomic)MyCamera *myCamera;
@property (strong, nonatomic) UIImageView *resultView;
@property (nonatomic) BOOL isDetect;
@end
@implementation MyVisionPersonSegmentationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.resultView = [[UIImageView alloc] initWithFrame:frame];
        self.resultView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.resultView];
        
        self.myCamera = [MyCamera new];
        self.myCamera.delegate = self;
        [self.myCamera startCapture];
    }
    
    return self;
}

#pragma mark MyCamera Delegate
- (void)getFrame:(UIImage *)frame{
    
    if(!self.isDetect){
        self.isDetect = YES;
        [MyVisionPersonSegmentation detect:frame result:^(UIImage * _Nonnull result) {
            self.resultView.image = result;
            self.isDetect = NO;
        }];
    }
    
}

@end
