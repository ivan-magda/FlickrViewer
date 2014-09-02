//
//  PSRClassWichPerformsAsyncOperations.h
//  PhotosViewer
//
//  Created by n.shubenkov on 31/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSRFlickrSearchOptions;

typedef void(^PSRComplitionBlock)(id result);

@interface PSRClassWichPerformsSomethingWithComplitionBlock: NSObject

- (void)performSomeOperationWithSearchOptions:(PSRFlickrSearchOptions *)options complition:(PSRComplitionBlock)complition;

@end
