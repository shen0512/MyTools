//
//  MyCamera.m
//  MyTools
//
//  Created by Shen on 2022/10/21.
//

#import "MyCamera.h"
#import "AVFoundation/AVFoundation.h"
#import "CoreMedia/CoreMedia.h"

@interface MyCamera()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureDeviceInput *deviceInput;

@end

@implementation MyCamera

- (instancetype)init{
    self = [super init];

    if(self){
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
            
        // Initialize the captureSession object.
        self.captureSession = [[AVCaptureSession alloc] init];
        // Set the input device on the capture session.
        [self.captureSession addInput:self.deviceInput];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
        self.captureHeight = 1920;
        self.captureWidth = 1080;
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        AVCaptureVideoDataOutput *captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.captureSession addOutput:captureVideoDataOutput];
        
        AVCaptureConnection *connection = [captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeStandard];
        
        // Create a new serial dispatch queue.
        [captureVideoDataOutput setSampleBufferDelegate:self queue:dispatch_queue_create("myQueue", NULL)];
    }
    
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIInterfaceOrientation interfaceOrientation;
        if (@available(iOS 13.0, *)){
            UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
            interfaceOrientation = firstWindow.windowScene.interfaceOrientation;
        } else {
            interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
        }

        switch(interfaceOrientation){
            case UIInterfaceOrientationLandscapeLeft:
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                break;

            case UIInterfaceOrientationLandscapeRight:
                [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                break;

            case UIInterfaceOrientationUnknown:
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            default:
                [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
        }
        CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext createCGImage:ciImage
                                                       fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];

        UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
        CGImageRelease(videoImage);

        if([self.delegate respondsToSelector:@selector(getFrame:)]){
            [self.delegate getFrame:uiImage];
        }
        
    });
    
}


- (void)startCapture{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
    
}

- (void)stopCapture{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession stopRunning];
    });
    
}

- (void)changeLens{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.captureSession isRunning]){
            [self.captureSession stopRunning];
        }
        
        if(self.deviceInput){
            [self.captureSession removeInput:self.deviceInput];
            self.deviceInput = nil;
        }
        
        AVCaptureDevice *captureDevice;
        if(self.isFrontLens){
            captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        }else{
            captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        }
        self.isFrontLens = !self.isFrontLens;
        self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        [self.captureSession addInput:self.deviceInput];
        [self.captureSession startRunning];
    });
    
}

@end
