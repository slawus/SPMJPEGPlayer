//
//  SPMJPEGMovie.h
//  SPMJPEGPlayer
//
//  Created by SP on 02/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGStream.h"

@interface SPMJPEGMovie : NSObject
+(SPMJPEGMovie *)movieWithContainer:(NSManagedObject *)moviewContainer;
@property (nonatomic, strong, readonly) NSManagedObject *coreDataContainer;
@property (nonatomic, strong) SPMJPEGStream *sourceStream;
@property (nonatomic, strong, readonly) SPMJPEGStream *movieStream;
@end
