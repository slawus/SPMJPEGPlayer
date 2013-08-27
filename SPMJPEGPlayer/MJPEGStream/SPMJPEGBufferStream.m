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
    NSTimer *timer;
    BOOL isPlaying;
}
-(id)initWithBuffer:(SPMJPEGFrameBuffer *)buffer
{
    self = [super init];
    
    if(self)
    {
        _buffer = buffer;
        isPlaying = NO;
        _buffer.delegate = self;
    }
    
    return self;
}

-(void)play
{
    if(!nextFrame)
    {
        nextFrame = [_buffer.frames objectAtIndex:0];
    }
     isPlaying = YES;
    [self changeFrame];
}

-(void)stop
{
    isPlaying = NO;
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
            [self stop];
            
            return;
        }
        nextFrame = [frames objectAtIndex:index];
    
    if(timer)
    {
        [timer invalidate];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:nextFrame.delay target:self selector:@selector(changeFrame) userInfo:nil repeats:NO];
    //[self performSelector:@selector(changeFrame) withObject:nil afterDelay:nextFrame.delay];
}


#pragma mark frameBufferDelegate
-(void)frameBuffer:(SPMJPEGFrameBuffer *)buffer frameAdded:(SPMJPEGFrame *)frame
{
    if(!isPlaying)
        [self play];
}
@end
