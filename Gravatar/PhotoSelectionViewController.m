//
//  PhotoSelectionViewController.m
//  Gravatar
//
//  Created by Beau Collins on 8/7/12.
//  Copyright (c) 2012 Beau Collins. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoSelectionViewController.h"

@interface PhotoSelectionViewController ()
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) ALAssetsLibrary *library;
@end

@implementation PhotoSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.photos = [NSMutableArray array];
	// Do any additional setup after loading the view.

    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {

            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    [self.photos addObject:result];
                }
            }];
            [self.collectionView reloadData];
            *stop = YES;
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to load photos: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    ALAsset *asset = [self.photos objectAtIndex:indexPath.row];
    CGImageRef image = [asset thumbnail];
    UIImageView *thumbView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:image]];
    thumbView.frame = CGRectMake(0.f, 0.f, 77.f, 77.f);
    [cell addSubview:thumbView];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoEditorViewController *editorController = [[PhotoEditorViewController alloc] init];
    editorController.photo = [self.photos objectAtIndex:indexPath.row];
    editorController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:editorController animated:YES completion:nil];
    
}

@end