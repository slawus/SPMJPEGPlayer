//
//  SPMJPEGMovieRecorder.m
//  SPMJPEGPlayer
//
//  Created by Slawek Pruchnik on 06.08.2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGToMp4Converter.h"

@implementation SPMJPEGToMp4Converter
{
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
    
    NSDate *lastFrameDate;
    
    double videoLength;
}

static CGSize size = {640, 480};

+(id)newMovieWithName:(NSString *)name
{
    SPMJPEGToMp4Converter *converter = [[SPMJPEGToMp4Converter alloc] init];
    converter.filename = name;
    
    return converter;
}

-(void)begin
{
        videoLength = 0;
    
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
        for (NSString *tString in dirContents)
        {
            if ([tString isEqualToString:self.filename])
            {
                [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,tString] error:nil];
                
            }
        } 
    
        path = [path stringByAppendingPathComponent:self.filename];
    
        NSLog(@"Write Started");
        NSError *error = nil;
    
        videoWriter = [[AVAssetWriter alloc] initWithURL:
                                      [NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4
                                                                  error:&error];
        NSParameterAssert(videoWriter);
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                       nil];
        
        
        videoWriterInput = [AVAssetWriterInput
                                                 assetWriterInputWithMediaType:AVMediaTypeVideo
                                                 outputSettings:videoSettings];
        
        adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                         sourcePixelBufferAttributes:nil];
        
        NSParameterAssert(videoWriterInput);
        
        NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
        videoWriterInput.expectsMediaDataInRealTime = YES;
        [videoWriter addInput:videoWriterInput];
        //Start a session:
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
}

-(void)newImage:(UIImage *)image withDelay:(double)delay
{
    videoLength += delay;
    
    //Video encoding
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    
    static int frameCount = 1;
    
    buffer = [self pixelBufferFromCGImage:image.CGImage size:size];
    
    
    BOOL append_ok = NO;
    int j = 0;
    while (!append_ok && j < 30)
    {
        if (adaptor.assetWriterInput.readyForMoreMediaData)
        {
            printf("appending %d attemp %d\n", frameCount, j);
            
            CMTime frameTime = CMTimeMake(videoLength*10,(int32_t) 10);
            frameTime = CMTimeMakeWithSeconds(videoLength, 100);
             NSLog(@"Frame time: %lld/%d", frameTime.value, frameTime.timescale);
            
            append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
            
            if(!append_ok)
            {
                NSLog(@"Writer status: %d", videoWriter.status);
                NSLog(@"Writer error: %@", videoWriter.error);
            }
            
            CVPixelBufferPoolRef bufferPool = adaptor.pixelBufferPool;
            NSParameterAssert(bufferPool != NULL);
            
            [NSThread sleepForTimeInterval:0.05];
        }
        else
        {
            printf("adaptor not ready %d, %d\n", frameCount, j);
            [NSThread sleepForTimeInterval:0.1];
        }
        j++;
    }
    if (!append_ok)
    {
        printf("error appending image %d times %d\n", frameCount, j);
    }
    frameCount++;
    CVBufferRelease(buffer);
}

-(void)newFrame:(SPMJPEGFrame *)frame
{
    [self newImage:frame.image withDelay:frame.delay];
}

-(void)finish
{
    [videoWriterInput markAsFinished];
    [videoWriter finishWritingWithCompletionHandler:^{
        
    }];
    
    NSLog(@"Write Ended");
}

- (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    status=status;//Added to make the stupid compiler not show a stupid warning.
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    //CGContextTranslateCTM(context, 0, CGImageGetHeight(image));
    //CGContextScaleCTM(context, 1.0, -1.0);//Flip vertically to account for different origin
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end
