//
//  MyVisionRectangle.m
//  MyTools
//
//  Created by Shen on 2022/10/29.
//

#import "MyVisionRectangle.h"
#import <Vision/Vision.h>
#import "MyVisionUtils.h"

@implementation MyVisionRectangle
+ (void)detect:(UIImage*)image results:(void(^)(NSArray * _Nullable results))results{
    VNDetectRectanglesRequest *detectRequest = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSArray *observations = request.results;
        
        if([observations count] > 0){
            NSMutableArray *tmpResults = [NSMutableArray new];
            for(VNRectangleObservation *observation in observations){
                
                [tmpResults addObject:@{@"bbox":@([MyVisionUtils bboxVision2UIImage:image bbox:observation.boundingBox]),
                                        @"points":@{
                                            @"tl":@([MyVisionUtils pointVision2UIImage:image :observation.topLeft]),
                                            @"tr":@([MyVisionUtils pointVision2UIImage:image :observation.topRight]),
                                            @"br":@([MyVisionUtils pointVision2UIImage:image :observation.bottomRight]),
                                            @"bl":@([MyVisionUtils pointVision2UIImage:image :observation.bottomLeft])
                                        }
                                      }];
            }
            results(tmpResults);
        }else{
            results(nil);
        }
        
    }];
    
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    NSError *err;
    [detectRequestHandler performRequests:@[detectRequest] error:&err];
}
@end
