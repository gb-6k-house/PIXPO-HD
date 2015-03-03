//
//  MMAboutViewController.m
//  P4PLive
//
//  Created by Maxwell on 14-4-6.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMAboutViewController.h"
#import "Utilities.h"
@interface MMAboutViewController ()

@end

@implementation MMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[Utilities viewBackgroundColor]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"about_txt", nil);

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
