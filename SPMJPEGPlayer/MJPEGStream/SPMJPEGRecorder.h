//
//  SPMJPEGRecorder.h
//  SPMJPEGPlayer
//
//  Created by SP on 15/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGStream.h"

@interface SPMJPEGRecorder : NSObject
+(id)recordMoviewFromStream:(SPMJPEGStream *)stream withName:(NSString *)name;
-(id)initWithSourceStream:(SPMJPEGStream *)stream moviewName:(NSString *)name;
-(void)finishRecording;

@property(nonatomic, strong, readonly) SPMJPEGStream *sourceStream;
@end
