//
//  SPMainViewController.h
//  SPMJPEGPlayer
//
//  Created by SP on 28/07/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPMJPEGStream.h"

@interface SPMainViewController : UIViewController<SPMJPEGStreamDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@end
