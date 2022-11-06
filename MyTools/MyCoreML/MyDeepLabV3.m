//
//  MyDeepLabV3.m
//  MyTools
//
//  Created by Shen on 2022/11/5.
//

#import "MyDeepLabV3.h"
#import "DeepLabV3.h"

@interface MyDeepLabV3()
@property (nonatomic) VNCoreMLModel *coreMLModel;

@end

@implementation MyDeepLabV3

- (instancetype)init{
    self = [super init];
    
    if(self){
        MLModel *deepLabV3Model = [[[DeepLabV3 alloc] init] model];
        self.coreMLModel = [VNCoreMLModel modelForMLModel:deepLabV3Model error:nil];
        
    }
    
    return self;
}

- (void)inference:(UIImage*)image result:(void(^)(MLMultiArray *result))result{
    VNCoreMLRequest *request = [[VNCoreMLRequest alloc] initWithModel:self.coreMLModel completionHandler: (VNRequestCompletionHandler) ^(VNRequest *request, NSError *error){
        NSArray *observations = request.results;
        VNCoreMLFeatureValueObservation *observation = observations.firstObject;
        result(observation.featureValue.multiArrayValue);
    }];

    request.imageCropAndScaleOption = VNImageCropAndScaleOptionScaleFill;
    CIImage *coreGraphicsImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:coreGraphicsImage  options:@{}];
    [handler performRequests:@[request] error:nil];
    
}
@end
