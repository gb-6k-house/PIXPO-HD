//
//  MMImageViewer.m
//  P4PLive
//
//  Created by Maxwell on 14-5-10.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMImageViewer.h"

@implementation MMImageViewer
@synthesize internalVisible;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createLoadingView];
    }
    return self;
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
    
    [self addSubview:loading];
    [self bringSubviewToFront:loading];
    return loading;
}

- (void)loading:(BOOL)visible {
    if (internalVisible == visible) {
        return;
    }
    
    internalVisible = visible;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    UIView *loadingView = [self viewWithTag:1123003];
    if (loadingView == nil){
        loadingView = [self createLoadingView];
    }
    loadingView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.userInteractionEnabled = !visible;
    
    if (visible) {
        loadingView.hidden = NO;
        [self bringSubviewToFront:loadingView];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
