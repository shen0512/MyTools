//
//  MyVisionUtils.m
//  MyTools
//
//  Created by Shen on 2022/10/24.
//

#import "MyVisionUtils.h"

@implementation MyVisionUtils

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
