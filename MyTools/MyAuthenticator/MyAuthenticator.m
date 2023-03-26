//
//  MyAuthenticator.m
//  MyTools
//
//  Created by Shen on 2023/3/23.
//

#import "MyAuthenticator.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation MyAuthenticator

+ (void)authenticator:(void(^)(BOOL success, NSString  * _Nullable error))result{
    LAContext *context = [[LAContext alloc] init];
//    context.localizedFallbackTitle = @""; // 更改 fall back 按鈕文字，空字串即可移除按鈕
//    context.localizedCancelTitle = @""; // 更改取消按鈕的文字
    NSError *error;
    NSString *reason = @"生物認證";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                                if(success){
                                    result(YES, nil);
                                }else{
                                    NSString *errorStr = @"";
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            errorStr = @"生物認證失敗";
                                            break;
                                                
                                        case LAErrorUserCancel:
                                            errorStr = @"生物認證取消";
                                            break;
                                                
                                        case LAErrorUserFallback:
                                            errorStr = @"使用者點擊輸入密碼";
                                            break;
                                            
                                        default:
                                            errorStr = @"生物認證失敗";
                                            break;
                                    }
                                    
                                    result(NO, errorStr);
                                }}];
    }else{
        result(NO, @"無法使用生物認證");
    }
}
@end
