//
//  FlickrViewController.m
//  FlickrViewer
//
//  Created by Ivan Magda on 02.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "FlickrViewController.h"
#import "PhotoDetailViewController.h"
#import "PSRClassWichPerformsAsyncOperations.h"
#import "PSRFlickrAPI.h"
#import "PSRFlickrPhoto.h"
#import "CollectionViewCell.h"


static const int kNumberOfPhotosThatAreVisible = 6;


@interface FlickrViewController ()

@property (nonatomic, strong) PSRFlickrSearchOptions *searchOptions;

@end


@implementation FlickrViewController {
    NSMutableArray *_photos;
    NSMutableArray *_parsedPhotosInfo;
}

#pragma mark - View Controller Life Cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
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

#pragma mark - Processing of requests for photos -

- (IBAction)showPhotos:(UIButton *)sender {
    [self configurateSearchOptions];
    
    _photos = [[NSMutableArray alloc]init];
    _parsedPhotosInfo = [[NSMutableArray alloc]init];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self.collectionView reloadData];
    });
    
    PSRClassWichPerformsSomethingWithComplitionBlock *customClassWithComplition = [PSRClassWichPerformsSomethingWithComplitionBlock new];
    
    [customClassWithComplition performSomeOperationWithSearchOptions:self.searchOptions complition:^(id result) {
        [self showPhotosFromEnumerator:[result objectEnumerator]];
    }];
}

- (void)showPhotosFromEnumerator:(NSEnumerator *)enumerator {
    dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", 0);
    dispatch_async(downloadQueue, ^{
        PSRFlickrPhoto *parsedPhoto = [enumerator nextObject];
        if (!parsedPhoto){
            return;
        }
        [_parsedPhotosInfo addObject:parsedPhoto];
        
        NSData *photoData = [NSData dataWithContentsOfURL:[parsedPhoto highQualityURL]];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [_photos addObject:[UIImage imageWithData:photoData]];
            
            NSLog(@"images downloaded %lu",(unsigned long)_photos.count);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_photos.count - 1 inSection:0];
            
            if (indexPath.row < kNumberOfPhotosThatAreVisible) {
                CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                cell.photo.image = _photos[indexPath.row];
            }             
            [self showPhotosFromEnumerator:enumerator];
        });
    });
}

- (void)configurateSearchOptions {
    NSString *itemsLimit = self.numberOfPhotosTextField.text;
    self.searchOptions.itemsLimit = [itemsLimit intValue];
    
    NSArray *tags = [self.tagTextField.text componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    self.searchOptions.tags = tags;
    NSLog(@"\ntags: %@ \n", tags);
}

#pragma mark - Text Field Delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - check the status of cell -

- (BOOL)showNextPhotosAfterSixStartersPhotos:(NSIndexPath *)indexPath {
    if ((indexPath.row > kNumberOfPhotosThatAreVisible - 1) && _photos[indexPath.row])
        return YES;
    else
        return NO;
}

- (BOOL)showPreviousPhotos:(NSIndexPath *)indexPath {
    if ((indexPath.row < kNumberOfPhotosThatAreVisible) && _photos.count != 0)
        return YES;
    else
        return NO;
}

#pragma mark - Collection View Data Source -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchOptions.itemsLimit;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *collectionCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSParameterAssert(collectionCell);
    
    NSLog(@"\nindexPath.row == %ld\n", (long)indexPath.row);
    
    if ([self showNextPhotosAfterSixStartersPhotos:indexPath]) {
        NSLog(@"\nAdding photo to up 6...\n");
        collectionCell.photo.image = _photos[indexPath.row];
    } else if ([self showPreviousPhotos:indexPath]) {
        collectionCell.photo.image = _photos[indexPath.row];
    } else if (_photos.count == 0) {
        collectionCell.photo.image = [[UIImage alloc]init];
    }
    return collectionCell;
}

#pragma mark - Collection View Delegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetail" sender:indexPath];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        NSIndexPath *path = sender;
        NSParameterAssert(path);
        
        PhotoDetailViewController *controller = segue.destinationViewController;
        controller.photoToShowDetail = _parsedPhotosInfo[path.row];
        controller.imageToShow = _photos[path.row];
    }
}

@end
