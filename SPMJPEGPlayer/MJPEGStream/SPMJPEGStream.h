//
// based on Motion-JPEG-Image-View-for-iOS
// url: https://github.com/mateagar/Motion-JPEG-Image-View-for-iOS
//
//  SPMJPEGStream.h
//  SPMJPEGPlayer
//
//  Created by SP on 28/07/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPMJPEGStreamDelegate;

@interface SPMJPEGStream : NSObject <NSURLConnectionDelegate>
{
    @private
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
}

@property (nonatomic, readwrite, copy) NSURL *url;
@property (readonly) BOOL isPlaying;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) BOOL allowSelfSignedCertificates;
@property (nonatomic) BOOL allowClearTextCredentials;
@property (nonatomic, strong, readonly) UIImage *frame;

@property (nonatomic, weak) id<SPMJPEGStreamDelegate> delegate;

-(void)connect;
-(void)disconnect;
@end

@protocol SPMJPEGStreamDelegate <NSObject>

-(void)mjpegStream:(SPMJPEGStream *)stream didReceiveFrame:(UIImage *)frame;
@end
