//
//  SPMJPEGFrameBuffer.h
//  SPMJPEGPlayer
//
//  Created by SP on 25/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGFrame.h"

@interface SPMJPEGFrameBuffer : NSObject

@property (nonatomic) double durationLimit;
@property (nonatomic) int frameCountLimit;
@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) int frameCount;
@property (nonatomic, strong, readonly) NSArray *frames;
-(void)addFrame:(SPMJPEGFrame *)frame;
@end
