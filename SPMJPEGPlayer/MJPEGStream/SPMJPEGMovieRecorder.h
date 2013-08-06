//
//  SPMJPEGMovieRecorder.h
//  SPMJPEGPlayer
//
//  Created by Slawek Pruchnik on 06.08.2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SPMJPEGFrame.h"
#import <CoreVideo/CoreVideo.h>

@interface SPMJPEGMovieRecorder : NSObject
-(id)recordMoviewWithName:(NSString *)name;
-(void)beginRecording;
-(void)newFrame:(SPMJPEGFrame *)frame;
-(void)newImage:(UIImage *)image withDelay:(double)delay;
-(void)finishRecording;

@property (nonatomic, strong, readonly) NSString *filename;
@end
