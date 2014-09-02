//
//  PhotoDetailViewController.m
//  FlickrViewer
//
//  Created by Ivan Magda on 02.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PSRFlickrPhoto.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSParameterAssert(self.imageToShow);
    self.photo.image = self.imageToShow;
    
    NSLog(@"%@",self.photoToShowDetail.info);
    NSString *title = [self.photoToShowDetail.info objectForKey:@"title"];
    NSParameterAssert(title);
    
    self.textView.text = title;
}

@end
