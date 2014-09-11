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


#pragma mark - ViewControllerLifeCycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textLabel.text = @"";
    
    [self setUpWithTitleAndImageDownload];
}

#pragma mark - Custom methods - 

- (void)setUpWithTitleAndImageDownload {
    [self.activityIndicator startAnimating];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("download queu", 0);
    dispatch_async(downloadQueue, ^{
        NSData *photoData = [NSData dataWithContentsOfURL:[self.photoToShowDetail highQualityURL]];
        if (photoData)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:photoData];
                NSParameterAssert(image);
                self.photo.image = image;
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidesWhenStopped = YES;
                
                NSLog(@"%@",self.photoToShowDetail.info);
                NSString *title = [self.photoToShowDetail.info objectForKey:@"title"];
                NSParameterAssert(title);
                self.textLabel.text = title;
                
                [self randomAnimate];
            });
        }
    });
}

#pragma mark - Animations -

- (void)randomAnimate {
    int randomAnimate = arc4random_uniform(2) + 1;
    switch (randomAnimate) {
        case 1:
            [self lightAppearance];
            break;
        case 2:
            [self increaseFromCenter];
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
}

- (void)lightAppearance {
    self.photo.alpha = 0.;
    self.textLabel.alpha = 0.;
    
    [UIView animateWithDuration:0.75
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.photo.alpha = 1.;
                         self.textLabel.alpha = 1.;
                     } completion:^(BOOL finished) {
                         finished = YES;
                     }];
}

- (void)increaseFromCenter {
    CGRect originalPhotoFrame = self.photo.frame;
    CGRect photoFrame = self.photo.frame;
    photoFrame.origin.x = 160;
    photoFrame.origin.y = 225;
    photoFrame.size.width = 0;
    photoFrame.size.height = 0;
    
    self.photo.frame = photoFrame;
    
    CGRect originalTextLabelFrame = self.textLabel.frame;
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 300;
    textLabelFrame.origin.y = 467;
    textLabelFrame.size.width = 0;
    textLabelFrame.size.height = 0;
    
    self.textLabel.frame = textLabelFrame;
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.photo.frame = originalPhotoFrame;
                         self.textLabel.frame = originalTextLabelFrame;
                     } completion:^(BOOL finished) {
                         finished = YES;
                     }];
}

@end
