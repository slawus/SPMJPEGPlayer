//
//  SPMJPEGFrameBuffer.h
//  SPMJPEGPlayer
//
//  Created by SP on 25/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGFrame.h"

@protocol SPMJPEGFrameBufferDelegate;

@interface SPMJPEGFrameBuffer : NSObject

@property (nonatomic) double durationLimit;
@property (nonatomic) int frameCountLimit;
@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) int frameCount;
@property (nonatomic, strong, readonly) NSArray *frames;

@property (nonatomic, weak) id<SPMJPEGFrameBufferDelegate> delegate;

-(void)addFrame:(SPMJPEGFrame *)frame;
@end

@protocol SPMJPEGFrameBufferDelegate <NSObject>
-(void)frameBuffer:(SPMJPEGFrameBuffer *)buffer frameAdded:(SPMJPEGFrame *)frame;
@end