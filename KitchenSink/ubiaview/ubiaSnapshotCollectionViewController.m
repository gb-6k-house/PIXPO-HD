//
//  ubiaSnapshotCollectionViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-18.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import "ubiaSnapshotCollectionViewController.h"
#import "ubiaSnapshotCell.h"
#import "ubiaSnapshotDetailViewController.h"
#import "ubiaDevice.h"
#import "Utilities.h"
#import "UIViewController+MMDrawerController.h"

#import "MMDrawerBarButtonItem.h"

@interface ubiaSnapshotCollectionViewController ()

@end

@implementation ubiaSnapshotCollectionViewController
@synthesize currentDevice;
@synthesize snapList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    snapList =  [Utilities getAllPictFilesUnderBaseDir];
    [self.collectionView reloadData];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
   	// Do any additional setup after loading the view.
    [self setupLeftMenuButton];
    //[self setupRightMenuButton];
    
    if(OSVersionIsAtLeastiOS7()){
        UIColor * barColor = [UIColor
                              colorWithRed:247.0/255.0
                              green:249.0/255.0
                              blue:250.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        UIColor * barColor = [UIColor
                              colorWithRed:78.0/255.0
                              green:156.0/255.0
                              blue:206.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    //MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
    //[self.navigationItem setTitleView:logo];
    //[self.navigationController.view.layer setCornerRadius:10.0f];
    

    //UIView *backView = [[UIView alloc] init];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:208.0/255.0
                                                 green:208.0/255.0
                                                  blue:208.0/255.0
                                                 alpha:1.0]];
    
    self.navigationItem.title = NSLocalizedString(@"snapshot_txt", nil);
    
}
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [snapList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    ubiaSnapshotCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"snapCellID" forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    //cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    //NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];

    //_thumbnail = [[UIImage imageWithContentsOfFile:path];
    //cell.image.image = [UIImage imageNamed:imageToLoad];
    cell.image.image = [Utilities loadImageFile: snapList[indexPath.row]];
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSnapFull"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
        //NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        //NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
        //UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
        ubiaSnapshotDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.snapList = snapList;
        //detailViewController.currenDevice = currentDevice;
        detailViewController.fileIndex = selectedIndexPath.row;

    }
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (IBAction)handleGestureforLongPress:(id)sender {
    NSLog(@"long press");
    
}



@end
