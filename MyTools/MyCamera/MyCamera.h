//
//  MyCamera.h
//  MyTools
//
//  Created by Shen on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MyCameraDelegate <NSObject>
- (void)getFrame:(UIImage*)frame;

@end

@interface MyCamera : NSObject
@property (nonatomic) id<MyCameraDelegate> delegate;
@property (nonatomic) NSInteger captureHeight;
@property (nonatomic) NSInteger captureWidth;
@property (nonatomic) BOOL isFrontLens;

- (instancetype)init;
- (void)startCapture;
- (void)stopCapture;
- (void)changeLens;
@end

NS_ASSUME_NONNULL_END
