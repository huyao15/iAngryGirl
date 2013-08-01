//
//  UIImage+Compress.h
//  AngryGirl
//
//  Created by Penuel on 13-7-29.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Compress)

- (UIImage *)compressedImage:(CGSize) mySize;

- (CGFloat)compressionQuality;

- (NSData *)compressedData;

- (NSData *)compressedData:(CGFloat)compressionQuality;

@end