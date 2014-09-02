//
//  FlickrViewController.m
//  FlickrViewer
//
//  Created by Ivan Magda on 02.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "FlickrViewController.h"
#import "PSRClassWichPerformsAsyncOperations.h"
#import "PSRFlickrAPI.h"
#import "PSRFlickrPhoto.h"


@interface FlickrViewController ()

@property (nonatomic, strong) PSRFlickrSearchOptions *searchOptions;

@end


@implementation FlickrViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PSRFlickrSearchOptions *options = [[PSRFlickrSearchOptions alloc]init];
    options.extra = @[@"original_format",
                      @"tags",
                      @"description",
                      @"geo",
                      @"date_upload",
                      @"owner_name"];
    self.searchOptions = options;
}

- (IBAction)showPhotos:(UIButton *)sender {
    PSRClassWichPerformsSomethingWithComplitionBlock *customClassWithComplition = [PSRClassWichPerformsSomethingWithComplitionBlock new];
    
    [customClassWithComplition performSomeOperationWithSearchOptions:self.searchOptions complition:^(id result) {
        [self showPhotosFromEnumerator:[result objectEnumerator]];
    }];
}

- (void)showPhotosFromEnumerator:(NSEnumerator *)enumarator {
    dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", 0);
    dispatch_async(downloadQueue, ^{
        NSLog(@"queue operation");
        PSRFlickrPhoto *parsedPhoto = [enumarator nextObject];
        if (!parsedPhoto){
            return;
        }
        
        NSData *photoData = [NSData dataWithContentsOfURL:[parsedPhoto highQualityURL]];
        
        NSLog(@"image downloaded");
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            self.photo.image = [UIImage imageWithData:photoData];
            [self showPhotosFromEnumerator:enumarator];
        });
    });
    NSLog(@"after calling dispatch_async");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self configurateSearchOptionsWithTextFiled:textField];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self configurateSearchOptionsWithTextFiled:textField];
}

- (void)configurateSearchOptionsWithTextFiled:(UITextField *)textField {
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        NSString *itemsLimit = self.numberOfPhotosTextField.text;
        self.searchOptions.itemsLimit = [itemsLimit intValue];
    } else {
        self.searchOptions.tags = @[self.tagTextField.text];
    }
}

@end
