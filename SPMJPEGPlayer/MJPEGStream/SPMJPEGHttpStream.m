//
//  SPMJPEGStream.m
//  SPMJPEGPlayer
//
//  Created by SP on 28/07/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMJPEGHttpStream.h"


#pragma mark - Constants

#define BEGIN_MARKER_BYTES { 0xFF, 0xD8 }
static NSData *_beginMarkerData = nil;

#define END_MARKER_BYTES { 0xFF, 0xD9 }
static NSData *_endMarkerData = nil;


@implementation SPMJPEGHttpStream
{
    NSDate *lastFrameDate;
}

-(BOOL)isPlaying { return !(_connection == nil); }
#pragma mark - Initializers

-(id)init {
    self = [super init];
    
    if (self)
    {
        _allowSelfSignedCertificates = NO;
        
        if (_endMarkerData == nil)
        {
            uint8_t endMarker[2] = END_MARKER_BYTES;
            _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
        }
        
        if(_beginMarkerData == nil)
        {
            uint8_t endMarker[2] = BEGIN_MARKER_BYTES;
            _beginMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
            
        }
    }
    
    return self;
}


#pragma mark - Overrides

-(void)dealloc
{
    if (_connection) {
        [_connection cancel];
        [self cleanupConnection];
    }
    
    _url = nil;
    _username = nil;
    _password = nil;
}

#pragma mark - Public Methods

-(void)play
{
    [self connect];
}

-(void)stop
{
    [self disconnect];
}

-(void)connect {
    if (_connection)
    {
        // continue
    }
    else if (_url) {
        /*if (_receivedData) {
         [_receivedData release];
         }*/
        _receivedData = [[NSMutableData alloc] init];
        
        _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url]
                                                      delegate:self];
    }
}

-(void)disconnect
{
    if (_connection) {
        [_connection cancel];
        [self cleanupConnection];
    }
}

#pragma mark - Private Methods

-(void)cleanupConnection
{
    _connection = nil;
    _receivedData = nil;
}

#pragma mark - NSURLConnection Delegate Methods


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    
    NSRange beginRange = [_receivedData rangeOfData:_beginMarkerData
                                            options:0
                                              range:NSMakeRange(0, _receivedData.length)];
    
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(beginRange.location+beginRange.length, _receivedData.length - (beginRange.location+beginRange.length))];
    
    if(endRange.location != NSNotFound){
        long endLocation = endRange.location + endRange.length;
        
        if (_receivedData.length >= endLocation){
            NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(beginRange.location, endLocation-beginRange.location)];
            
            [_receivedData replaceBytesInRange:NSMakeRange(0, endLocation) withBytes:NULL length:0];
            
            UIImage *receivedImage = [UIImage imageWithData:imageData];
            if (receivedImage)
            {
                static double movieSize = 0;
                movieSize += imageData.length;
                
                NSLog(@"Frame size in kb: %f, since begining: %f", imageData.length / 1024.0, movieSize / 1024.0);
                
                double delay = (!lastFrameDate) ? 0 : -[lastFrameDate timeIntervalSinceNow];
                
                lastFrameDate = [NSDate date];
                
                self.frame = [SPMJPEGFrame frameWithImage:receivedImage timeDelay:delay];
            }
        }
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self cleanupConnection];
}

-(BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL allow = NO;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        allow = _allowSelfSignedCertificates;
    }
    else {
        allow = _allowClearTextCredentials;
    }
    
    return allow;
}

-(void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0 &&
        _username && _username.length > 0 &&
        _password && _password.length > 0) {
        NSURLCredential *credentials =
        [NSURLCredential credentialWithUser:_username
                                   password:_password
                                persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credentials
               forAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [self cleanupConnection];
        
        NSLog(@"SPMJPEGStream: Authentication failed");
    }
}

-(BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cleanupConnection];
}

@end