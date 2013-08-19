//
//  SPMJPEGFrame.m
//  SPMJPEGPlayer
//
//  Created by Slawek Pruchnik on 06.08.2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGFrame.h"

@implementation SPMJPEGFrame
+(SPMJPEGFrame *)frameWithImage:(UIImage *)image timeDelay:(double)delay
{
    SPMJPEGFrame *frame = [[SPMJPEGFrame alloc] init];
    frame->_delay = delay;
    frame->_image = image;
    
    return frame;
}
@end
