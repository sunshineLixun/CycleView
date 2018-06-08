//
//  UIImageView+Ex.m
//  smartFM952
//
//  Created by lixun on 2017/4/24.
//  Copyright © 2017年 gzbd. All rights reserved.
//

#import "UIImageView+Ex.h"

@implementation UIImageView (Ex)

-(void)drawImage:(UIImage *)image targetSize:(CGSize )size{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        CGRect newRect = CGRectMake(0, 0, size.width, size.height);
        CGRectIntegral(newRect);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
        CGContextConcatCTM(context, transform);
        CGContextSaveGState(context);
        CGContextDrawImage(context, newRect, image.CGImage);
        CGContextRestoreGState(context);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newImage) {
                self.layer.contents = (id)(newImage.CGImage);
            }
        });
    });
}

@end
