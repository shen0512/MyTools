//
//  MyVisionFace.m
//  MyTools
//
//  Created by Shen on 2022/10/23.
//

#import "MyVisionFace.h"
#import <Vision/Vision.h>

@interface MyVisionFace()
@property (nonatomic, strong) VNImageBasedRequest *detectRequest;

@end

@implementation MyVisionFace

+ (void)detectFace:(UIImage*)image results:(void(^)(NSArray *results))results{
    VNDetectFaceRectanglesRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observations = request.results;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){

            if([observations count] > 0){
                NSMutableArray *tmpResult = [NSMutableArray new];
                for(VNFaceObservation *face in observations){
                    CGRect tmpBbox = [self visionBbox2UIImageBbox:image bbox:[face boundingBox]];
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

+ (void)detectFaceWithLandmark:(UIImage*)image results:(void(^)(NSDictionary *results))results{
    
    VNDetectFaceLandmarksRequest *detectRequest = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observations = request.results;

            if([observations count] > 0){
                NSMutableArray *tmpBboxResults = [NSMutableArray new];
                NSMutableArray *tmpLandmarkResults = [NSMutableArray new];
                for(VNFaceObservation *face in observations){
                    CGRect tmpBbox = [face boundingBox];
                    [tmpBboxResults addObject:@([self visionBbox2UIImageBbox:image bbox:tmpBbox])];
                    
                    VNFaceLandmarkRegion2D *landmarks = face.landmarks.allPoints;
                    NSMutableArray *tmpPoints = [NSMutableArray new];
                    for(int i=0; i<[landmarks pointCount]; i++){
                        CGPoint tmpPoint = [self visionPoint2UIImagePoint:image :tmpBbox :landmarks.normalizedPoints[i]];
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

#pragma mark Bounding box tools
+ (CGRect)visionBbox2UIImageBbox:(UIImage*)image bbox:(CGRect)bbox{
    /**
     @brief Vision 座標轉換成 UIImage 座標
     @param bbox vision bounding box result
     @return 轉換後的結果
     */
    CGFloat tlx = bbox.origin.x*image.size.width;
    CGFloat tly = bbox.origin.y*image.size.height;
    CGFloat width = bbox.size.width*image.size.width;
    CGFloat height = bbox.size.height*image.size.height;
    
    return CGRectMake(tlx, image.size.height-height-tly, width, height);
}

+ (CGPoint)visionPoint2UIImagePoint:(UIImage*)image :(CGRect)bbox :(CGPoint)point{
    /**
     @brief Vision 座標轉換成 UIImage 座標
     ＠param bbox vision bounding box
     @param point vision landmark result
     @return 轉換後的結果
     */
    float x = (point.x*bbox.size.width+bbox.origin.x)*image.size.width;
    float y = (1-(point.y*bbox.size.height+bbox.origin.y))*image.size.height;
    
    return CGPointMake(x, y);
    
}

@end
