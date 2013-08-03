//
//  SPMoviesRepository.m
//  SPMJPEGPlayer
//
//  Created by SP on 02/08/2013.
//  Copyright (c) 2013 SP. All rights reserved.
//

#import "SPMoviesRepository.h"

@implementation SPMoviesRepository

+(NSManagedObjectContext *)context
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    return context;
}

+(void)saveContext
{
    NSManagedObjectContext *context = [self context];
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(void)deleteMovie:(SPMJPEGMovie *)movie
{
    NSManagedObjectContext *context = [self context];
    [context deleteObject:movie.coreDataContainer];
    
    [self saveContext];
}


+(SPMJPEGMovie *)newMovie
{
    NSManagedObjectContext *context = [self context];
    
    NSManagedObject *movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    
    NSDate *date = [NSDate date];
    
    //title
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    [movie setValue:dateString forKey:@"title"];
    [movie setValue:[NSNumber numberWithLongLong:[date timeIntervalSince1970]] forKey:@"date"];
    
    [self saveContext];
    
    SPMJPEGMovie *movieObject = [SPMJPEGMovie movieWithContainer:movie];
    
    return movieObject;
}

+(NSArray *)getAllSavedMovies
{
    NSManagedObjectContext *context = [self context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Movie" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    for (NSManagedObject *movieContainer in fetchedObjects)
    {
        [movies addObject:[SPMJPEGMovie movieWithContainer:movieContainer]];
    }
    
    return movies;
}
@end
