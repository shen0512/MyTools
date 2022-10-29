//
//  MyVisionUtils.m
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import "MyVisionUtils.h"

@implementation MyVisionUtils

+ (CGRect)bboxVision2UIImage:(UIImage*)image bbox:(CGRect)bbox{
    
    CGFloat tlx = bbox.origin.x*image.size.width;
    CGFloat tly = bbox.origin.y*image.size.height;
    CGFloat width = bbox.size.width*image.size.width;
    CGFloat height = bbox.size.height*image.size.height;
    
    return CGRectMake(tlx, image.size.height-height-tly, width, height);
}

+ (CGPoint)landmarkVision2UIImage:(UIImage*)image :(CGRect)bbox :(CGPoint)point{
    
    CGFloat x = (point.x*bbox.size.width+bbox.origin.x)*image.size.width;
    CGFloat y = (1-(point.y*bbox.size.height+bbox.origin.y))*image.size.height;
    
    return CGPointMake(x, y);
    
}
+ (CGPoint)pointVision2UIImage:(UIImage*)image :(CGPoint)point{
    CGFloat x = (point.x)*image.size.width;
    CGFloat y = (1-(point.y))*image.size.height;
    
    return CGPointMake(x, y);
}

+ (CGPoint)pointUIImage2Vision:(UIImage*)image :(CGPoint)point{
    CGFloat x = point.x;
    CGFloat y = image.size.height - point.y;
    
    return CGPointMake(x, y);
}

+ (UIImage*)perspectiveCorrection:(UIImage*)image points:(NSDictionary*)points{
    
    CIImage *ciImage = image.CIImage;
    if(!ciImage){
        ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    }
    
    CGPoint tl = [self pointUIImage2Vision:image :[points[@"tl"] CGPointValue]];
    CGPoint tr = [self pointUIImage2Vision:image :[points[@"tr"] CGPointValue]];
    CGPoint bl = [self pointUIImage2Vision:image :[points[@"bl"] CGPointValue]];
    CGPoint br = [self pointUIImage2Vision:image :[points[@"br"] CGPointValue]];
    
    NSDictionary *parameters = @{@"inputTopLeft": [[CIVector alloc] initWithCGPoint:tl],
                                 @"inputTopRight": [[CIVector alloc] initWithCGPoint:tr],
                                 @"inputBottomLeft": [[CIVector alloc] initWithCGPoint:bl],
                                 @"inputBottomRight": [[CIVector alloc] initWithCGPoint:br]};
    
    ciImage = [ciImage imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:parameters];
    UIImage *result = [UIImage imageWithCIImage:ciImage];
    
    return result;
}

@end
