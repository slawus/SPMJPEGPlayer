//
//  SPMJPEGRecorder.m
//  SPMJPEGPlayer
//
//  Created by SP on 15/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGRecorder.h"
#import "SPMJPEGToMp4Converter.h"

@implementation SPMJPEGRecorder
{
    SPMJPEGToMp4Converter *_converter;
}
+(id)recordMoviewFromStream:(SPMJPEGStream *)stream withName:(NSString *)movieName;
{
    SPMJPEGRecorder *recorder = [[SPMJPEGRecorder alloc] initWithSourceStream:stream moviewName:movieName];
    
    return recorder;
}

-(id)initWithSourceStream:(SPMJPEGStream *)stream moviewName:(NSString *)name
{
    self = [super init];
    
    if(self)
    {
        _converter = [[SPMJPEGToMp4Converter alloc] init];
        _converter.filename = [name stringByAppendingFormat:@".mp4"];
        [_converter begin];
        
        _sourceStream = stream;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameReceived:) name:@"newFrame" object:_sourceStream];
        
    }
    
    return self;
}

-(void)frameReceived:(NSNotification *)notification
{
    if(notification.object != _sourceStream)
        return;
    
    [_converter newFrame:_sourceStream.frame];
}

-(void)finishRecording
{
    [_converter finish];
    
    _converter = nil;
}
-(void)dealloc
{
    _sourceStream = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
