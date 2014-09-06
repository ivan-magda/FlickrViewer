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
    // Вот тут уже можно в фоне скачать фото в хорошем качестве.
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSParameterAssert(self.imageToShow);
    //присвоение изображений лучше переместить  во  viewDidLoad т.к. это нужно сделать только один раз
    self.photo.image = self.imageToShow;
    
    NSLog(@"%@",self.photoToShowDetail.info);
    NSString *title = [self.photoToShowDetail.info objectForKey:@"title"];
    NSParameterAssert(title);
    
    self.textLabel.text = title;
    
    int randomAnimate = arc4random_uniform(2) + 1;
    switch (randomAnimate) {
        case 1:
            [self animateView1];
            break;
        case 2:
            [self animateView2];
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
}
//прикольная анимация! Круто!!
- (void)animateView1 {
    self.photo.alpha = 0.;
    self.textLabel.alpha = 0.;
    
    [UIView animateWithDuration:0.75
                          delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.photo.alpha = 1.;
                         self.textLabel.alpha = 1.;
                     } completion:^(BOOL finished) {
                         finished = YES;
                     }];
}

- (void)animateView2 {
    CGRect photoFrame = self.photo.frame;
    photoFrame.origin.x = 160;
    photoFrame.origin.y = 225;
    photoFrame.size.width = 0;
    photoFrame.size.height = 0;
    
    self.photo.frame = photoFrame;
    
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
                         CGRect pFrame = self.photo.frame;
                         pFrame.origin.x = 0;
                         pFrame.origin.y = 70;
                         pFrame.size.width = 320;
                         pFrame.size.height = 310;
                         self.photo.frame = pFrame;
                         
                         CGRect tFrame = self.textLabel.frame;
                         tFrame.origin.x = 20;
                         tFrame.origin.y = 386;
                         tFrame.size.width = 280;
                         tFrame.size.height = 162;
                         self.textLabel.frame = tFrame;
                     } completion:^(BOOL finished) {
                         finished = YES;
                     }];
}

@end
