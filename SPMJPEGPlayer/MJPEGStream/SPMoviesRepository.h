//
//  SPMoviesRepository.h
//  SPMJPEGPlayer
//
//  Created by SP on 02/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMJPEGMovie.h"

@interface SPMoviesRepository : NSObject
+(SPMJPEGMovie *)newMovie;
+(NSArray *)getAllSavedMovies;
+(void)deleteMovie:(SPMJPEGMovie *)movie;
+(void)saveContext;
+(NSManagedObjectContext *)context;

@end
