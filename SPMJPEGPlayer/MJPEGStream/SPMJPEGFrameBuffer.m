//
//  SPMJPEGFrameBuffer.m
//  SPMJPEGPlayer
//
//  Created by SP on 25/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGFrameBuffer.h"

@implementation SPMJPEGFrameBuffer
{
    NSMutableArray *_frames;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        _duration = 0;
        _durationLimit = INFINITY;
        _frameCountLimit = INFINITY;
        
        //init array
        _frames = [NSMutableArray array];
    }
    
    return  self;
}

-(NSArray *)frames
{
    return [_frames copy];
}

-(int)frameCount
{
    return [_frames count];
}

-(void)setFrameCountLimit:(int)frameCountLimit
{
    _frameCountLimit = frameCountLimit;
    
   [self adjustBuffer];
}

-(void)setDurationLimit:(double)durationLimit
{
    _durationLimit = durationLimit;
    
   [self adjustBuffer];
}

-(void)adjustBuffer
{
    while(_duration > _durationLimit)
    {
        [self removeFirstFrame];
    }
    
    while(self.frameCount >  _frameCountLimit)
    {
        [self removeFirstFrame];
    }
}
    


-(void)addFrame:(SPMJPEGFrame *)frame
{
    _duration += frame.delay;
    [_frames addObject:frame];
    
    if([self.delegate respondsToSelector:@selector(frameBuffer:frameAdded:)])
        [self.delegate frameBuffer:self frameAdded:frame];
}

-(void)removeFirstFrame
{
    SPMJPEGFrame *frame = [_frames objectAtIndex:0];
    _duration -= frame.delay;
    
    [_frames removeObject:frame];
}
@end
