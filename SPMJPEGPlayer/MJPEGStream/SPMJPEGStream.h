//
//  SPMJPEGStream.h
//  SPMJPEGPlayer
//
//  Created by SP on 03/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SPMJPEGStreamDelegate;

@interface SPMJPEGStream : NSObject
@property (readonly) BOOL isPlaying;
@property (nonatomic, strong) UIImage *frame;
@property (nonatomic, weak) id<SPMJPEGStreamDelegate> delegate;

-(void)play;
-(void)stop;
@end

@protocol SPMJPEGStreamDelegate <NSObject>
-(void)mjpegStream:(SPMJPEGStream *)stream didReceiveFrame:(UIImage *)frame;
@end
