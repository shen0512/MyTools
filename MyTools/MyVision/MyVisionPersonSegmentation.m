//
//  MyVisionPersonSegmentation.m
//  MyTools
//
//  Created by Shen on 2022/12/3.
//

#import "MyVisionPersonSegmentation.h"
#import <Vision/Vision.h>

@implementation MyVisionPersonSegmentation

+ (void)detect:(UIImage*)image result:(void(^)(UIImage *result))result{
    if (@available(iOS 15.0, *)) {
        VNGeneratePersonSegmentationRequest *detectRequest = [[VNGeneratePersonSegmentationRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            
            VNPixelBufferObservation *observation = request.results.firstObject;
            CVPixelBufferRef pixelBufferRef = observation.pixelBuffer;
            
            result([self pixelBuffer2UIImage:pixelBufferRef]);
        }];
        
        CIImage *convertImage = [[CIImage alloc] initWithImage:image];
        VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
        
        NSError *err;
        [detectRequestHandler performRequests:@[detectRequest] error:&err];
    } else {
        // Fallback on earlier versions
        NSLog(@"最低需求為: iOS 15");
        result(nil);
    }
}

+ (UIImage*)pixelBuffer2UIImage:(CVPixelBufferRef)pixelBuffer{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                       createCGImage:ciImage
                       fromRect:CGRectMake(0, 0,
                              CVPixelBufferGetWidth(pixelBuffer),
                              CVPixelBufferGetHeight(pixelBuffer))];

    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    
    return uiImage;
}

@end
