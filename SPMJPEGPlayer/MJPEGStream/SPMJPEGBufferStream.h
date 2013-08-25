//
//  SPMJPEGBufferStream.h
//  SPMJPEGPlayer
//
//  Created by SP on 25/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGFrameBuffer.h"
#import "SPMJPEGStream.h"

@interface SPMJPEGBufferStream : SPMJPEGStream<SPMJPEGFrameBufferDelegate>

@property(nonatomic, readonly) SPMJPEGFrameBuffer *buffer;

-(id)initWithBuffer:(SPMJPEGFrameBuffer *)buffer;
-(void)goToPercent:(double)percentDuration;
@end
