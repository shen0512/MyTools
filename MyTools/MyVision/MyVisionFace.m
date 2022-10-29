//
//  MyVisionFace.m
//  MyTools
//
//  Created by Shen on 2022/10/23.
//

#import "MyVisionFace.h"
#import <Vision/Vision.h>
#import "MyVisionUtils.h"

@implementation MyVisionFace

+ (void)detect:(UIImage*)image results:(void(^)(NSArray *results))results{
    VNDetectFaceRectanglesRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observations = request.results;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){

            if([observations count] > 0){
                NSMutableArray *tmpResult = [NSMutableArray new];
                for(VNFaceObservation *face in observations){
                    CGRect tmpBbox = [MyVisionUtils visionBbox2UIImageBbox:image bbox:[face boundingBox]];
                    [tmpResult addObject:@(tmpBbox)];
                }
                results(tmpResult);
                
            }else{
                results([NSArray new]);
            }
            
        });
    }];
    
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    NSError *err;
    [detectRequestHandler performRequests:@[detectRequest] error:&err];
    
}

+ (void)detectWithLandmark:(UIImage*)image results:(void(^)(NSDictionary *results))results{
    
    VNDetectFaceLandmarksRequest *detectRequest = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observations = request.results;

            if([observations count] > 0){
                NSMutableArray *tmpBboxResults = [NSMutableArray new];
                NSMutableArray *tmpLandmarkResults = [NSMutableArray new];
                for(VNFaceObservation *face in observations){
                    CGRect tmpBbox = [face boundingBox];
                    [tmpBboxResults addObject:@([MyVisionUtils visionBbox2UIImageBbox:image bbox:tmpBbox])];
                    
                    VNFaceLandmarkRegion2D *landmarks = face.landmarks.allPoints;
                    NSMutableArray *tmpPoints = [NSMutableArray new];
                    for(int i=0; i<[landmarks pointCount]; i++){
                        CGPoint tmpPoint = [MyVisionUtils visionPoint2UIImagePoint:image :tmpBbox :landmarks.normalizedPoints[i]];
                        [tmpPoints addObject:@(tmpPoint)];
                    }
                    [tmpLandmarkResults addObject:tmpPoints];
                }
                
                results(@{@"bboxes":tmpBboxResults, @"landmarks":tmpLandmarkResults});
            }else{
                results(@{@"bboxes":[NSArray new], @"landmarks":[NSArray new]});
            }

    }];
    
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    NSError *err;
    [detectRequestHandler performRequests:@[detectRequest] error:&err];

}

@end
