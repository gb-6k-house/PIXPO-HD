// Copyright (c) 2013 UBIA (http://ubia.cn/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMExampleViewController.h"
#import "MMAppDelegate.h"

@interface MMExampleViewController ()

@end

@implementation MMExampleViewController
@synthesize internalVisible;

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
    if(OSVersionIsAtLeastiOS7()){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(contentSizeDidChangeNotification:)
         name:UIContentSizeCategoryDidChangeNotification
         object:nil];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

-(void)contentSizeDidChange:(NSString *)size{
    //Implement in subclass
}

- (UIView *)createLoadingView {
    
    UIView *loading = [[UIView alloc] init];
    loading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    loading.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    loading.tag = 1123003;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    [activity sizeToFit];
    activity.center = CGPointMake(loading.center.x, loading.frame.size.height/3);
    activity.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    
    [loading addSubview:activity];
    
    
    [self.view addSubview:loading];
    [self.view bringSubviewToFront:loading];
    return loading;
}

- (void)loading:(BOOL)visible {
    if (internalVisible == visible) {
        return;
    }
    
    internalVisible = visible;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    UIView *loadingView = [self.view viewWithTag:1123003];
    if (loadingView == nil){
        loadingView = [self createLoadingView];
    }
    loadingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.userInteractionEnabled = !visible;
    
    if (visible) {
        loadingView.hidden = NO;
        [self.view bringSubviewToFront:loadingView];
    }
    
    loadingView.alpha = visible ? 0 : 1;
    [UIView animateWithDuration:0.3
                     animations:^{
                         loadingView.alpha = visible ? 1 : 0;
                     }
                     completion: ^(BOOL  finished) {
                         if (!visible) {
                             loadingView.hidden = YES;
                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                         }
                     }];
}

- (NSUInteger)supportedInterfaceOrientations {
    
    //NSLog(@"MMDrawerController+Storyboard ==>supportedInterfaceOrientations");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(!appDelegate.rotationEnabled){
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}

@end
