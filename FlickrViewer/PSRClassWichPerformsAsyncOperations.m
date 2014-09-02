//
//  PSRClassWichPerformsAsyncOperations.m
//  PhotosViewer
//
//  Created by n.shubenkov on 31/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "PSRClassWichPerformsAsyncOperations.h"
#import "PSRFlickrAPI.h"


@interface PSRClassWichPerformsSomethingWithComplitionBlock()

@end

@implementation PSRClassWichPerformsSomethingWithComplitionBlock

- (void)performSomeOperationWithSearchOptions:(PSRFlickrSearchOptions *)options complition:(PSRComplitionBlock)complition
{
    //make copy of block, wich was passed to you
    PSRComplitionBlock copiedComplition = [complition copy];
    
    //do some long task.
    //make performing this task in background
    dispatch_queue_t requestQueue = dispatch_queue_create("request queue", 0);
    dispatch_async(requestQueue, ^{
        NSArray *photos = [[[PSRFlickrAPI alloc]init]requestPhotosWithOptions:options];
        
        NSLog(@"Request made");
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (copiedComplition){
                copiedComplition(photos);
            }
        });
    });
}

@end
