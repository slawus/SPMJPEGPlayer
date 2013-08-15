//
//  SPMoviewPlayerViewController.m
//  SPMJPEGPlayer
//
//  Created by SP on 15/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface SPMoviePlayerViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

@implementation SPMoviePlayerViewController

-(MPMoviePlayerController *)moviePlayer
{
    if(!_moviePlayer)
    {
        _moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:self.movieUrl];
    
        _moviePlayer.controlStyle = MPMovieControlStyleDefault;
        _moviePlayer.shouldAutoplay = YES;
    }
    
    return _moviePlayer;
}

-(void)setMovieUrl:(NSURL *)movieUrl
{
    _movieUrl = movieUrl;
    
    self.moviePlayer.contentURL = movieUrl;
}

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.moviePlayer.contentURL = _movieUrl;
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer setFullscreen:YES animated:YES];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:_movieUrl];
    
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    NSLog(@"duration: %.2f", seconds);
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.moviePlayer play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
