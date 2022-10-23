//
//  NSString+Utils.m
//  MyTools
//
//  Created by Shen on 2022/10/22.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (CGFloat)stringWidth:(UIFont *)font{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] size].width;
}

- (CGFloat)stringHeight:(UIFont *)font{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] size].height;
}

@end
