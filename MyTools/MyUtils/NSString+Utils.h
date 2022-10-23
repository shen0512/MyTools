//
//  NSString+Utils.h
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)
- (CGFloat)stringWidth:(UIFont *)font;
- (CGFloat)stringHeight:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
