//
//  PhotoDetailViewController.h
//  FlickrViewer
//
//  Created by Ivan Magda on 02.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSRFlickrPhoto;

@interface PhotoDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) PSRFlickrPhoto *photoToShowDetail;
@property (nonatomic, strong) UIImage *imageToShow;

@end
