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

-(void)goToPercent:(double)percentDuration
{
    NSArray *frames = self.buffer.frames;
    
    int index = ([frames count] - 1)*percentDuration;
    
    nextFrame = [frames objectAtIndex:index];
}


-(void)changeFrame
{

        NSArray *frames = self.buffer.frames;
        
        int index = [frames indexOfObject:nextFrame];
        if(index == NSNotFound)
            index = -1;
        
        index += 1;
    
    NSLog(@"Frame index: %d/%d %d", index, frames.count, self.buffer.frameCount);
    
        self.frame = nextFrame;
        
        if(index >= [frames count])
        {
            //_buffer.delegate = self;
            
            return;
        }
        nextFrame = [frames objectAtIndex:index];
    
    
    [self performSelector:@selector(changeFrame) withObject:nil afterDelay:nextFrame.delay];
}


#pragma mark frameBufferDelegate
-(void)frameBuffer:(SPMJPEGFrameBuffer *)buffer frameAdded:(SPMJPEGFrame *)frame
{
    
}
@end
