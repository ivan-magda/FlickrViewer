//
//  FlickrViewController.h
//  FlickrViewer
//
//  Created by Ivan Magda on 02.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPhotosTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)showPhotos:(UIButton *)sender;

@end
