//
//  SPMainViewController.m
//  SPMJPEGPlayer
//
//  Created by SP on 28/07/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMainViewController.h"
#import "SPMJPEGHttpStream.h"
#import "SPMJPEGRecorder.h"

@interface SPMainViewController ()
{
    UIImageView *imageView;
    bool isRecording;
    SPMJPEGRecorder *recorder;
    SPMJPEGHttpStream *stream;
}
@end

@implementation SPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    [self.view insertSubview:imageView belowSubview:self.recordButton];
    
    //load mjpeg stream
    stream = [[SPMJPEGHttpStream alloc] init];
    stream.url = [NSURL URLWithString:@"http://192.168.1.103:8080"];
    stream.delegate = self;
    
    [stream connect];
    
    isRecording = NO;
}
- (IBAction)recordButtonPressed:(id)sender
{
    if(recorder)
    {
        [recorder finishRecording];
        recorder = nil;
    }
    else
    {
        recorder = [SPMJPEGRecorder recordMoviewFromStream:stream withName:@"newMoview"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark delegate
-(void)mjpegStream:(SPMJPEGStream *)stream didReceiveFrame:(SPMJPEGFrame *)frame
{
    imageView.image = frame.image;
}
@end
