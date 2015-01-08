//
//  UIImage+Common.m
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIImage+Common.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Common)

+ (UIImage *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//UIView转换为UIImage
+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    newSize.width = (int)newSize.width;
    newSize.height = (int)newSize.height;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)squareImage
{
    CGSize imgSize = self.size;
    if (imgSize.width !=  imgSize.height) {
        CGFloat image_x =0.0;
        CGFloat image_y =0.0;
        UIImage *image = nil;
        if (imgSize.width >  imgSize.height) {
            image_x = (imgSize.width -imgSize.height)/2;
            image = [self imageClipedWithRect:CGRectMake(image_x, 0, imgSize.height, imgSize.height)];
        }else{
            image_y = (imgSize.height -imgSize.width)/2;
            image = [self imageClipedWithRect:CGRectMake(0,image_y, imgSize.width, imgSize.width)];
        }
        return image;
    }
    return self;
}

- (UIImage *)imageClipedWithRect:(CGRect)clipRect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);

    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage* clipImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return clipImage;
}


//模糊化图片
- (UIImage *)bluredImageWithBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

//黑白图片
- (UIImage*)monochromeImage
{
    CIImage *beginImage = [CIImage imageWithCGImage:[self CGImage]];
    
    CIColor *ciColor = [CIColor colorWithCGColor:[UIColor lightGrayColor].CGColor];
    CIFilter *filter = nil;
    CIImage *outputImage;
    
    filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, kCIInputColorKey, ciColor, nil];
    outputImage = [filter outputImage];
    
    [EAGLContext setCurrentContext:nil];

    return  [UIImage imageWithCIImage:outputImage];
}


@end
