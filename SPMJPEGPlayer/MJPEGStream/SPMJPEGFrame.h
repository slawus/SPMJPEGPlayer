//
//  SPMJPEGFrame.h
//  SPMJPEGPlayer
//
//  Created by Slawek Pruchnik on 06.08.2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPMJPEGFrame : NSObject
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, readonly) double delay;

+(SPMJPEGFrame *)frameWithImage:(UIImage *)image timeDelay:(double)delay;
@end
