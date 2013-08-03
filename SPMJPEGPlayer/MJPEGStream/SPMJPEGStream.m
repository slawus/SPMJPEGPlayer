//
//  SPMJPEGStream.m
//  SPMJPEGPlayer
//
//  Created by SP on 03/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGStream.h"

@implementation SPMJPEGStream

-(void)setFrame:(UIImage *)frame
{
    if(frame)
    {
        _frame = frame;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newFrame" object:nil];
    }
    
    if([self.delegate respondsToSelector:@selector(mjpegStream:didReceiveFrame:)])
    {
        [self.delegate mjpegStream:self didReceiveFrame:frame];
    }
}

-(void)play
{
    [NSNotificationCenter defaultCenter];
    [[NSException exceptionWithName:@"Incomplete implementation" reason:@"This is abstract method. You must implement this." userInfo:nil] raise];
}

-(void)stop
{
    [[NSException exceptionWithName:@"Incomplete implementation" reason:@"This is abstract method. You must implement this." userInfo:nil] raise];
}
@end
