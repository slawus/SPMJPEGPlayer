//
//  SPMJPEGBufferStream.m
//  SPMJPEGPlayer
//
//  Created by SP on 25/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGBufferStream.h"

@implementation SPMJPEGBufferStream
{
    SPMJPEGFrame *nextFrame;
}
-(id)initWithBuffer:(SPMJPEGFrameBuffer *)buffer
{
    self = [super init];
    
    if(self)
    {
        _buffer = buffer;
    }
    
    return self;
}

-(void)play
{
    if(!nextFrame)
    {
        nextFrame = [_buffer.frames objectAtIndex:0];
    }
    
    [self changeFrame];
}

-(void)stop
{
    nextFrame = nil;
}

-(void)changeFrame
{
    @synchronized(self)
    {
        NSArray *frames = self.buffer.frames;
        
        int index = [frames indexOfObject:nextFrame];
        if(index == NSNotFound)
            index = -1;
        
        index += 1;
        
        self.frame = nextFrame;
        
        if(index >= [frames count])
        {
            nextFrame = nil;
            [self stop];
        }
        nextFrame = [frames objectAtIndex:index];
        
        [self performSelector:@selector(changeFrame) withObject:nil afterDelay:nextFrame.delay];
    }
}

@end
