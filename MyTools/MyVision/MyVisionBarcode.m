//
//  MyVisionBarcode.m
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import "MyVisionBarcode.h"
#import <Vision/Vision.h>
#import "MyVisionUtils.h"

@implementation MyVisionBarcode

+ (void)detect:(UIImage*)image results:(void(^)(NSArray *results))results{
    VNDetectBarcodesRequest *detectRequest = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        NSArray *observations = request.results;
        if([observations count] > 0){
            NSMutableArray *tmpResult = [NSMutableArray new];
            for(VNBarcodeObservation *barocde in observations){
                [tmpResult addObject:@{@"value":barocde.payloadStringValue,
                                       @"bbox":@([MyVisionUtils bboxVision2UIImage:image bbox:barocde.boundingBox]),
                                       @"conf":@(barocde.confidence)
                                     }];
            }
            results(tmpResult);
        }else{
            results(nil);
        }
    }];
    
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    NSError *err;
    [detectRequestHandler performRequests:@[detectRequest] error:&err];
}

+ (void)detectWithMaxConf:(UIImage*)image results:(void(^)(NSDictionary * _Nullable results))results{
    VNDetectBarcodesRequest *detectRequest = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        NSArray *observations = request.results;
        if([observations count] > 0){
            NSMutableDictionary *tmpResult = [NSMutableDictionary new];
            for(VNBarcodeObservation *barocde in observations){
                NSString *value = barocde.payloadStringValue;
                if([tmpResult objectForKey:value]){
                    CGFloat tmpConf = [tmpResult[value][@"conf"] floatValue];
                    if(barocde.confidence > tmpConf){
                        tmpResult[value] = @{@"bbox":@([MyVisionUtils bboxVision2UIImage:image bbox:barocde.boundingBox]),
                                             @"conf":@(barocde.confidence)};
                    }
                    
                }else{
                    tmpResult[value] = @{@"bbox":@([MyVisionUtils bboxVision2UIImage:image bbox:barocde.boundingBox]),
                                         @"conf":@(barocde.confidence)};
                }
            }
            results(tmpResult);
            
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
