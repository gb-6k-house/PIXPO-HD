//
//  ubiaSettingViewController.m
//  P4PCamLive
//
//  Created by work on 13-4-17.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaSettingViewController.h"
#import "ubiaDevice.h"
@interface ubiaSettingViewController ()

@end

@implementation ubiaSettingViewController
@synthesize currentDevice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setCurrentDevice: (id)device{
    currentDevice = device;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[label setFont: [UIFont fontWithName:@"Arial" size:50.0]];
    
	// Do any additional setup after loading the view.
    NSArray *labelArrary = [NSArray  arrayWithObjects:@"UID",@"Password",@"Alert",@"Night Mode",
                            @"Microphone Volume",@"Speaker Volume",@"Resolution",@"Picture Quality",
                            @"Frame Rate",@"Bit Rate",@"Brightness",@"Contrast",@"Saturation",nil];
    
    int num = [labelArrary count];
    int i;
    for(i=0; i<num; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25*i+20.0f, 120.0f,16.0f)];
        label.text = labelArrary[i];
        [label setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview: label];
        if(i == 0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 25*i+20.0f, 128.0f,16.0f)];
            [self.view addSubview: label];
        }else if(i==1){
            UITextField *txt = [[UITextField alloc] initWithFrame:CGRectMake(150.0f, 25*i+20.0f, 128.0f,16.0f)];
            //txt.text = device.Password.text;
            [self.view addSubview: txt];
            
        }else if(i<4){
            UISwitch *uswitch = [[UISwitch alloc] initWithFrame:CGRectMake(150.0f, 25*i+20.0f, 128.0f,16.0f)];
            [self.view addSubview: uswitch];
        }else{
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(150.0f, 25*i+20.0f, 128.0f,16.0f)];
            [slider setValue:0.5];
            [self.view addSubview: slider];
        }
        
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
