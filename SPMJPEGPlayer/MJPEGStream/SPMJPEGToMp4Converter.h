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

@interface SPMJPEGToMp4Converter : NSObject
+(id)newMovieWithName:(NSString *)name;
-(void)begin;
-(void)newFrame:(SPMJPEGFrame *)frame;
-(void)newImage:(UIImage *)image withDelay:(double)delay;
-(void)finish;

@property (nonatomic, strong) NSString *filename;
@end
