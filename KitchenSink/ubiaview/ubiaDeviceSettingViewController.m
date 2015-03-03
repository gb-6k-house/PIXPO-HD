//
//  ubiaDeviceSettingViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-15.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaDeviceSettingViewController.h"
#import "ubiaDeviceAdvanceSettingViewController.h"

#import "ubiaDevice.h"
#import "ubiaDeviceSettings.h"
#import "ubiaDeviceChannelSettings.h"

#import "ubiaSetting+TextFieldCell.h"
#import "ubiaSettingSheetViewController.h"

#import  "MMAppDelegate.h"
#import  "ubiaRestClient.h"
#import "ubiaDeviceManager.h"

extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface ubiaDeviceSettingViewController ()
{
    BOOL isAppear;
    BOOL hasShowAlert;
}
@end

@implementation ubiaDeviceSettingViewController
@synthesize currentDevice;
@synthesize nameSectionArray;
@synthesize basicSectionArray;
@synthesize items,values;
@synthesize selectCellPath;
@synthesize newvalue;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        isAppear = FALSE;
        [self createLoadingView];
        hasShowAlert = FALSE;
    }
    return self;
}

- (UIView *)createLoadingView {
    
    UIView *loading = [[UIView alloc] init];
    loading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    loading.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    loading.tag = 1123002;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    [activity sizeToFit];
    activity.center = CGPointMake(loading.center.x, loading.frame.size.height/3);
    activity.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    
    [loading addSubview:activity];
    
    [self.tableView addSubview:loading];
    [self.tableView bringSubviewToFront:loading];
    return loading;
}

- (void)loading:(BOOL)visible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    UIView *loadingView = [self.tableView viewWithTag:1123002];
    if (loadingView == nil || loadingView == NULL){
        loadingView = [self createLoadingView];
    }
    if (loadingView == nil || loadingView == NULL ) {
        return;
    }
    loadingView.frame = CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    self.tableView.userInteractionEnabled = !visible;
    
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

- (void)startTheBackgroundJob {
	// wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
    //[NSThread sleepForTimeInterval:3];
    int retVal = -1;
    int retry = 0;
    BOOL gotDeviceInfoWithExt = FALSE;
    
    [NSThread setThreadPriority:0.1];
    
    //[NSThread sleepForTimeInterval:0.1];
    BACKEND_IOCTL_MSG * pIOMsg = (BACKEND_IOCTL_MSG *) ioctrlRecvBuf;
    [self loading:YES];

    
    [currentDevice requestDeviceInfo];
    
    currentDevice.isWaitIOResp = true;
    while (isAppear && currentDevice.isWaitIOResp) {
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.3];
        }else{
            
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_DEVINFO_RESP){
                    SMsgAVIoctrlDeviceInfoResp * pRsp = (SMsgAVIoctrlDeviceInfoResp *)(pIOMsg + 1);

                    currentDevice.settings.vendor = [NSString stringWithUTF8String:(char *)pRsp->vendor];
                    currentDevice.settings.model = [NSString stringWithUTF8String:(char *)pRsp->model];

                    
                    NSString *version = [NSString stringWithFormat:@"%d.%d.%d.%d",(pRsp->version &0xff000000)>>24,(pRsp->version &0x00ff0000)>>16,(pRsp->version &0x0000ff00)>>8, (pRsp->version &0x000000ff)];
                    
                    currentDevice.settings.version = version;
                    currentDevice.settings.totalChannels = pRsp->channel;
                    currentDevice.settings.storageCapacity = pRsp->total;
                    currentDevice.settings.storageFree = pRsp->free;
                    if (pRsp->valid == 0x7E) {
                        NSLog(@"got All Device Info=====>");
                        gotDeviceInfoWithExt = TRUE;
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.videoQuality = pRsp->videoquality;
                        chn.flipMirror = pRsp->videoflips;
                        
                        if (pRsp->envmode == 0) {
                            chn.envMode = pRsp->envmode;
                        }else{
                            chn.envMode = pRsp->envmode -1;
                        }
                        chn.mdSensitivity = pRsp->motionsensitivity/25;
                        chn.alarmMode = pRsp->alarmmode;
                        chn.recordMode = pRsp->recordmode;
                        
                        
                    }
                    if (FALSE == hasShowAlert) {
                        hasShowAlert = TRUE;
                        if (pRsp->total == -1) {
                            //Notify
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:NSLocalizedString(@"notify_format_storage", nil)
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"format_storage_btn", nil)
                                                                  otherButtonTitles:NSLocalizedString(@"close_btn", nil),nil
                                                  ];
                            [alert show];
                        }else if(pRsp->total == 0){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:NSLocalizedString(@"notify_no_storage", nil)
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"close_btn", nil)
                                                                  otherButtonTitles:nil,nil
                                                  ];
                            [alert show];
                        }
                    }

                    break;
                }
                
            }else{
                
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestDeviceInfo];
                    retry++;
                }else{
                    break;
                }
            }
            if(retry > 3) break;
        }
    }
    if (gotDeviceInfoWithExt) {
        currentDevice.isWaitIOResp = false;
        [self loading:NO];

        return;
    }
    
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestDeviceEnvMode];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
                [NSThread sleepForTimeInterval:0.3];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP){
                    SMsgAVIoctrlGetEnvironmentResp * pRsp = (SMsgAVIoctrlGetEnvironmentResp *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.envMode = pRsp->mode;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestDeviceEnvMode];
                    retry++;
                }else{
                    break;
                }
                
            }
            if(retry > 3) break;
        }
    }
    
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestVideoMode];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.3];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP){
                    SMsgAVIoctrlGetVideoModeResp * pRsp = (SMsgAVIoctrlGetVideoModeResp *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.flipMirror = pRsp->mode;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestVideoMode];
                    retry++;
                }else{
                    break;
                }

            }
            if(retry > 3) break;
        }
    }
#if 1
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestVideoQuality];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.5];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP){
                    SMsgAVIoctrlGetStreamCtrlResq * pRsp = (SMsgAVIoctrlGetStreamCtrlResq *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.videoQuality = pRsp->quality - 1;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestVideoQuality];
                    retry++;
                }else{
                    break;
                }
                

            }
            if(retry > 3) break;
        }
    }
#endif
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestRecordMode];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.3];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GETRECORD_RESP){
                    SMsgAVIoctrlGetRecordResq * pRsp = (SMsgAVIoctrlGetRecordResq *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.recordMode = pRsp->recordType;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestRecordMode];
                    retry++;
                }else{
                    break;
                }

            }
            if(retry > 3) break;
        }
    }

    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestMDSensitivity];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.3];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP){
                    SMsgAVIoctrlGetMotionDetectResp * pRsp = (SMsgAVIoctrlGetMotionDetectResp *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.mdSensitivity = pRsp->sensitivity/25;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestMDSensitivity];
                    retry++;
                }else{
                    break;
                }
            }
            if(retry > 3) break;
        }
    }
    
    currentDevice.isWaitIOResp = false;
    
#if 0
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestAudioSensitivity];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.5];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GETAUDIOSENSITIVITY_RSP){
                    SMsgAVIoctrlGetMotionDetectResp * pRsp = (SMsgAVIoctrlGetMotionDetectResp *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.audioSensitivity = pRsp->sensitivity/25;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestAudioSensitivity];
                    retry++;
                }else{
                    break;
                }
            }
            if(retry > 2) break;
        }
    }
    
    currentDevice.isWaitIOResp = false;
    
    currentDevice.isWaitIOResp = true;
    retry = 0;
    [currentDevice requestMDSensitivity];
    while (isAppear && currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.3];
        }else{
            //retVal = recvIOControl(currentDevice.avIndex, 2000);
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:1000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_GETTEMPSENSITIVITY_RSP){
                    SMsgAVIoctrlGetMotionDetectResp * pRsp = (SMsgAVIoctrlGetMotionDetectResp *)(pIOMsg + 1);
                    if([currentDevice.settings.chnSettings count] > pRsp->channel){
                        ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[pRsp->channel];
                        chn.tempSensitivity = pRsp->sensitivity/25;
                    }
                    currentDevice.isWaitIOResp = false;
                    
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestTempSensitivity];
                    retry++;
                }else{
                    break;
                }
            }
            if(retry > 2) break;
        }
    }
#endif
    currentDevice.isWaitIOResp = false;
    [self loading:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doEdit:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    nameSectionArray = @[
                    NSLocalizedString(@"name", nil),
                    NSLocalizedString(@"password", nil),
                    NSLocalizedString(@"UID", nil)];
    //@[@"Name",@"Password",@"UID"];
    
    //basicSectionArray =@[@"Video Quality",@"Flip & Mirror",@"Environment Mode"];
    basicSectionArray = @[NSLocalizedString(@"device_info", nil) ];
    
    items = [NSMutableArray arrayWithCapacity:8];
    values = [NSMutableArray arrayWithCapacity:8];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSettingChangeFunc:) name: @"ubiaDeviceSettingNotification" object:nil];

    self.navigationItem.title = NSLocalizedString(@"settings_txt", nil);

}
- (IBAction)handleEditEnd:(UITextField *)sender {
    NSLog(@"%s, tag =%d",__FUNCTION__, sender.tag);
    
    switch (sender.tag) {
        case 0:
            currentDevice.name = [sender text];
            break;
        case 1:
            currentDevice.client.password = [sender text];
            break;
        default:
            break;
    }
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.deviceManager.restClient device_op:currentDevice operate:DEVICE_OP_MODIFY];
}

- (void)handleSettingChangeFunc:(NSNotification *)note{
    NSLog(@"Received notification: %@", note);
    NSString *nameStr = [[note userInfo] objectForKey:NSLocalizedString(@"name", nil)];
    NSString *pwdStr = [[note userInfo] objectForKey:NSLocalizedString(@"password", nil)];
    NSString * uidStr = [[note userInfo] objectForKey:NSLocalizedString(@"UID", nil)];
    if(nameStr != nil){
        currentDevice.name = nameStr;
    }
    if(pwdStr != nil){
        currentDevice.client.password = pwdStr;
    }
    if(uidStr != nil){
        currentDevice.uid = uidStr;
    }
    
    NSArray *myKeys = [NSArray arrayWithObjects:@"ubiaDevice",nil];
    
    NSArray *myObjects = [NSArray arrayWithObjects: currentDevice,nil];
    NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"ubiaMasterViewNotification" object:nil userInfo: myTestDictionary];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.deviceManager.restClient device_op:currentDevice operate:DEVICE_OP_MODIFY];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isAppear = TRUE;
    [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isAppear = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = [nameSectionArray count];
            break;
        case 1:
            rows = [basicSectionArray count];
            break;
        case 2:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell;
    
    switch (section) {
        case 0:
        {
             ubiaSetting_TextFieldCell * ubiaCell = (ubiaSetting_TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
            if(ubiaCell == nil){
                ubiaCell = [[ubiaSetting_TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
            }

            ubiaCell.attrLabel.text = nameSectionArray[row];
            ubiaCell.attrValue.tag = row;
            switch (row) {
                case 0:
                    ubiaCell.attrValue.text = currentDevice.name;
                    break;
                case 1:
                    ubiaCell.attrValue.text = currentDevice.client.password;
                    //ubiaCell.attrValue.secureTextEntry = TRUE;
                    break;
                case 2:
                    ubiaCell.attrValue.text = currentDevice.uid;

                    ubiaCell.attrValue.userInteractionEnabled = NO;
                    break;
                default:
                    break;
            }
            cell = ubiaCell;

        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"mydetailCell" forIndexPath:indexPath];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mydetailCell"];
            }
            cell.textLabel.text = basicSectionArray[row];
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"mydefaultCell" forIndexPath:indexPath];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mydefaultCell"];
            }
        
            cell.textLabel.text = NSLocalizedString(@"advanced_settings", nil);//@"Advanced Setting";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSettingSheet"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"segue prepare to %@",[segue identifier]);

        [items removeAllObjects];
        [values removeAllObjects];
        //ubiaDeviceChannelSettings *chn0 = currentDevice.settings.chnSettings[0];
        ubiaSettingSheetViewController * settingSheetView = [segue destinationViewController];

        switch (indexPath.row) {
            case 0:
                [items addObject:NSLocalizedString(@"model", nil)];
                [items addObject:NSLocalizedString(@"firmware_version", nil)] ;
                [items addObject:NSLocalizedString(@"vendor", nil)];
                
                if(currentDevice.settings.model)
                    [values addObject:currentDevice.settings.model];
                else
                    [values addObject: NSLocalizedString(@"unknown", nil)];

                if(currentDevice.settings.version)
                    [values addObject:currentDevice.settings.version];
                else
                    [values addObject: NSLocalizedString(@"unknown", nil)];
                
                if(currentDevice.settings.vendor)
                    [values addObject:currentDevice.settings.vendor];
                else
                    [values addObject: NSLocalizedString(@"unknown", nil)];
                
                [items addObject:NSLocalizedString(@"total_space", nil)];
                [items addObject:NSLocalizedString(@"free_space", nil)];

                
                if(currentDevice.settings.storageCapacity)
                    [values addObject:[NSString stringWithFormat:@"%u MB",(unsigned int)currentDevice.settings.storageCapacity]];
                else
                    [values addObject:@"0 MB"];
                
                if(currentDevice.settings.storageCapacity)
                    [values addObject:[NSString stringWithFormat:@"%u MB",(unsigned int)currentDevice.settings.storageFree]];
                else
                    [values addObject:@"0 MB"];
                
                if(currentDevice.settings.storageCapacity){
                    [items addObject:NSLocalizedString(@"format_storage", nil)];
                    [values addObject:@""];
                }
                break;

                break;
            default:
                break;
        }

        settingSheetView.itemArray = items;
        settingSheetView.valueArray = values;

       
    }else if ([[segue identifier] isEqualToString:@"goAdvanceSetting"]) {
        //ubiaDeviceAdvanceSettingViewController * settingSheetView = [segue destinationViewController];
        //settingSheetView.currentDevice = currentDevice;

        [[segue destinationViewController]setCurrentDevice:currentDevice];
    };

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (IBAction)doEdit:(id)sender {
    return;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    
#pragma unused(alertView)
#pragma unused(buttonIndex)
    //assert(alertView == self.alertView);
    //assert(buttonIndex == 0);
    if (buttonIndex == 0) {
        NSLog(@"Sure to format");
        [currentDevice formatStorage:0];
        
    }else{
        NSLog(@"cancel to format");
    }
    
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}
@end
