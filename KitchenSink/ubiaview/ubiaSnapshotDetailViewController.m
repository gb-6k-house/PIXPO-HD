/*
     File: DetailViewController.m
 Abstract: The secondary detailed view controller for this app.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "ubiaSnapshotDetailViewController.h"
#import "ubiaDevice.h"
#import "Utilities.h"



#import "MMAppDelegate.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface ubiaSnapshotDetailViewController ()
//@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ubiaSnapshotDetailViewController{
    BOOL isPortraitOrientation;
}

@synthesize fileIndex;
@synthesize snapList;
@synthesize imageView;
@synthesize showNavBar;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.rotationEnabled = TRUE;
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeUp];
    [self.view addGestureRecognizer:self.swipeDown];
   
    self.title = [NSString stringWithFormat:@"%d/%d",fileIndex+1,[snapList count]];
    //[self.view removeGestureRecognizer:self.swipeLeftRecognizer];
    int orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        //we set the init default
        //isPortraitOrientation = FALSE;
        [self setPortraitOrientation: FALSE];
        
    }else{
        //isPortraitOrientation = TRUE;
        [self setPortraitOrientation: TRUE];
        
    }

}
-(void) setPortraitOrientation:(BOOL) isPortrait{
    
    isPortraitOrientation = isPortrait;
    
    if(FALSE == isPortraitOrientation){
        showNavBar = FALSE;
        self.navigationController.navigationBarHidden = TRUE;
        self.toolbar.hidden = TRUE;
    }else{
        showNavBar = TRUE;
        self.navigationController.navigationBarHidden = FALSE;
        self.toolbar.hidden = FALSE;
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.rotationEnabled = FALSE;
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    [super viewWillDisappear:animated];
}
- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    //if ((gestureRecognizer == self.tapRecognizer)) {
    //    return NO;
    //}
    return YES;
}


#pragma mark -
#pragma mark Responding to gestures

/*
 In response to a tap gesture, show the image view appropriately then make it fade out in place.
 */
- (IBAction)showGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer {
	
	CGPoint location = [recognizer locationInView:self.view];
	[self drawImageForGestureRecognizer:recognizer atPoint:location];
	
	[UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
    }];
}


/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (IBAction)handleGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    //CGPoint location = [sender locationInView:self.view];
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"swipe to left");
        case UISwipeGestureRecognizerDirectionUp:

            NSLog(@"swipe to Up");
            if(fileIndex > 0) {
                fileIndex -= 1;
                self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"swipe to Right");
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"swipe to Down");
            if(fileIndex < [snapList count] -1) {
                fileIndex += 1;
                self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];;
            }
            break;

        default:
            break;
    }
    self.title = [NSString stringWithFormat:@"%d/%d",fileIndex+1,[snapList count]];
}


- (IBAction)showGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer {
    
	CGPoint location = [recognizer locationInView:self.view];
	[self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 220.0;
    }
    else {
        location.x += 220.0;
    }
    
	[UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
        self.imageView.center = location;
    }];
}


/*
 In response to a rotation gesture, show the image view at the rotation given by the recognizer. At the end of the gesture, make the image fade out in place while rotating back to horizontal.
 */
- (IBAction)showGestureForRotationRecognizer:(UIRotationGestureRecognizer *)recognizer {
	
	CGPoint location = [recognizer locationInView:self.view];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation([recognizer rotation]);
    self.imageView.transform = transform;
	[self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    /*
     If the gesture has ended or is cancelled, begin the animation back to horizontal and fade out.
     */
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}


#pragma mark -
#pragma mark Drawing the image view

/*
 Set the appropriate image for the image view for the given gesture recognizer, move the image view to the given point, then dispay the image view by setting its alpha to 1.0.
 */
- (void)drawImageForGestureRecognizer:(UIGestureRecognizer *)recognizer atPoint:(CGPoint)centerPoint {
    
	NSString *imageName;
    
    if ([recognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        imageName = @"tap.png";
    }
    else if ([recognizer isMemberOfClass:[UIRotationGestureRecognizer class]]) {
        imageName = @"rotation.png";
    }
    else if ([recognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        imageName = @"swipe.png";
    }
    
	self.imageView.image = [UIImage imageNamed:imageName];
	self.imageView.center = centerPoint;
	self.imageView.alpha = 1.0;
}

- (IBAction)handleClickLeftBtn:(id)sender {
    if(fileIndex > 0) {
        fileIndex -= 1;
        self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];
        self.title = [NSString stringWithFormat:@"%d/%d",fileIndex+1,[snapList count]];
    }
    
}
- (IBAction)handleClickRightBtn:(id)sender {
    if(fileIndex < [snapList count] - 1) {
        fileIndex += 1;
        self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];
        self.title = [NSString stringWithFormat:@"%d/%d",fileIndex+1,[snapList count]];
    }
}

- (IBAction)handleClickDeleteBtn:(id)sender {
    
    [Utilities deleteImageFile:snapList[fileIndex]];
    
    snapList = [Utilities getAllPictFilesUnderBaseDir];
    
    if([snapList count] > 0){
        if(fileIndex > [snapList count] -1)
            fileIndex = [snapList count] -1;
        self.imageView.image = [Utilities loadImageFile:snapList[fileIndex]];
        self.title = [NSString stringWithFormat:@"%d/%d",fileIndex+1,[snapList count]];
    }else{
        fileIndex = 0;
        self.title = [NSString stringWithFormat:@"0/0"];
        self.imageView.image = nil;
    }
    
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    if(showNavBar){
        self.navigationController.navigationBarHidden = TRUE;
        self.toolbar.hidden = TRUE;
        showNavBar = FALSE;
    }
    else{
        self.navigationController.navigationBarHidden = FALSE;
        self.toolbar.hidden = FALSE;
        showNavBar = TRUE;
    }
}


- (void)viewDidUnload {
//    [self setClickLeftBtn:nil];
//    [self setClickRightBtn:nil];
    [super viewDidUnload];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
-(void) handle{
    
    int orientation = [[UIDevice currentDevice] orientation];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    //int nh = self.navigationController.navigationBar.frame.size.height;
    
    NSLog(@"(w:%d h:%d) rotate %d", width,height,orientation);
    switch (orientation) {
            
        case UIDeviceOrientationPortrait:
            imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
            showNavBar = TRUE;
            self.navigationController.navigationBarHidden = FALSE;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
            showNavBar = TRUE;
            self.navigationController.navigationBarHidden = FALSE;
            break;
        case UIDeviceOrientationLandscapeLeft:
            imageView.frame = CGRectMake(0, 0, width, height);
            showNavBar = FALSE;
            self.navigationController.navigationBarHidden = TRUE;
            break;
        case UIDeviceOrientationLandscapeRight:
            imageView.frame = CGRectMake(0, 0, width, height);
            showNavBar = FALSE;
            self.navigationController.navigationBarHidden = TRUE;
            break;
        case UIDeviceOrientationFaceUp:
            imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
            break;
        case UIDeviceOrientationFaceDown:
            imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
            
        default:
            break;
    }
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"from rotate %d", fromInterfaceOrientation);
    [self handleOrientationLayout];
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)){

        isPortraitOrientation = TRUE;
        showNavBar = TRUE;
        self.navigationController.navigationBarHidden = FALSE;
        self.toolbar.hidden = FALSE;
    
    }else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)){
        isPortraitOrientation = FALSE;
        
        showNavBar = FALSE;
        self.navigationController.navigationBarHidden = TRUE;
        self.toolbar.hidden = TRUE;
        
        
        //self.playbackBtn.hidden = FALSE;
        //self.goLiveBtn.hidden = FALSE;
        
    }
}

-(void) handleOrientationLayout{
    
    //int orientation = [[UIDevice currentDevice] orientation];
    //CGSize screen_bounds = [[UIScreen mainScreen] bounds].size;
    
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    
    
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        if( [[UIScreen mainScreen] bounds].size.height >= 568 || [[UIScreen mainScreen] bounds].size.width >= 568 )
        {
            //IPHONE 5/5C/5S
            if(isPortraitOrientation){
                
                imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);

                
                _toolbar.frame = CGRectMake(0,height-44, width, 44);
                
            }else{
                imageView.frame = CGRectMake(0, 0, width, height);
                
                
                _toolbar.frame = CGRectMake(0,height-44, width, 44);
            }
        }
        else
        {
            //IPHONE 4S/4/IPOD
            if(isPortraitOrientation){
                imageView.frame = CGRectMake(0, 96, 320, 180);
                
                _toolbar.frame = CGRectMake(0,height-44, 320, 44);
                
            }else{
                
                imageView.frame = CGRectMake(0, 0, width, height);
                
                _toolbar.frame = CGRectMake(0,height-44, width, 44);
                
            }
            
        }
    }
    
}



@end
