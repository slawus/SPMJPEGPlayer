//
//  SPMainViewController.m
//  SPMJPEGPlayer
//
//  Created by SP on 28/07/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMainViewController.h"


@interface SPMainViewController ()
{
    UIImageView *imageView;
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
    
    [self.view addSubview:imageView];
    
    //load mjpeg stream
    SPMJPEGStream *stream = [[SPMJPEGStream alloc] init];
    stream.url = [NSURL URLWithString:@"http://192.168.1.102:8080"];
    stream.delegate = self;
    
    [stream connect];
    [self newMovie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newMovie
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    
    NSDate *date = [NSDate date];
    
    //title
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    [movie setValue:dateString forKey:@"title"];
    [movie setValue:[NSNumber numberWithLongLong:[date timeIntervalSince1970]] forKey:@"date"];
    
    
    
    
    /* NSManagedObject *failedBankInfo = [NSEntityDescription
     insertNewObjectForEntityForName:@"FailedBankInfo"
     inManagedObjectContext:context];
     [failedBankInfo setValue:@"Test Bank" forKey:@"name"];
     [failedBankInfo setValue:@"Testville" forKey:@"city"];
     [failedBankInfo setValue:@"Testland" forKey:@"state"];
     NSManagedObject *failedBankDetails = [NSEntityDescription
     insertNewObjectForEntityForName:@"FailedBankDetails"
     inManagedObjectContext:context];
     [failedBankDetails setValue:[NSDate date] forKey:@"closeDate"];
     [failedBankDetails setValue:[NSDate date] forKey:@"updateDate"];
     [failedBankDetails setValue:[NSNumber numberWithInt:12345] forKey:@"zip"];
     [failedBankDetails setValue:failedBankInfo forKey:@"info"];
     [failedBankInfo setValue:failedBankDetails forKey:@"details"];*/
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Movie" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Title: %@", [info valueForKey:@"title"]);
    }
}


#pragma mark delegate
-(void)mjpegStream:(SPMJPEGStream *)stream didReceiveFrame:(UIImage *)frame
{
    imageView.image = frame;
}
@end
