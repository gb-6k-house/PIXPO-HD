//
//  ubiaDeviceAdvanceSettingViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-6-7.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import "ubiaDeviceAdvanceSettingViewController.h"
#import "ubiaSettingSheetViewController.h"
#import "ubiaDevice.h"
#import "ubiaDeviceSettings.h"
#import "ubiaDeviceChannelSettings.h"
#import "ubiaSecurityCodeViewController.h"

@interface ubiaDeviceAdvanceSettingViewController ()

@end

@implementation ubiaDeviceAdvanceSettingViewController
@synthesize currentDevice;
@synthesize items,values;
@synthesize newvalue,selectCellPath;

#define WITH_ALARM_MODE

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    items = [NSMutableArray arrayWithCapacity:8];
    values = [NSMutableArray arrayWithCapacity:8];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"segue prepare to %@",[segue identifier]);
    
    [items removeAllObjects];
    [values removeAllObjects];
    ubiaDeviceChannelSettings *chn0 = currentDevice.settings.chnSettings[0];
    
    if ([[segue identifier] isEqualToString:@"goTextSheetFromAdvance"]) {

         ubiaSecurityCodeViewController * settingSheetView = [segue destinationViewController];
        
        settingSheetView.currentDevice = currentDevice;

    }
    else if ([[segue identifier] isEqualToString:@"goSettingSheetFromAdvance"]) {

        ubiaSettingSheetViewController * settingSheetView = [segue destinationViewController];

        switch (indexPath.section) {
            case 0:
                //[items addObject:@"Old Password"];
                //[items addObject:@"New Password"];
                //[items addObject:@"Retry Password"];
                break;
            case 1:
                switch (indexPath.row) {
#if  0
                    case 0:
                        [items addObject:NSLocalizedString(@"max",nil)];
                        [items addObject:NSLocalizedString(@"high",nil)];
                        [items addObject:NSLocalizedString(@"medium",nil)];
                        [items addObject:NSLocalizedString(@"low",nil)];
                        [items addObject:NSLocalizedString(@"min",nil)];
                        
                        settingSheetView.checkedIndex = chn0.videoQuality;
                        break;
#endif
                    case 0:
                        [items addObject:NSLocalizedString(@"normal",nil)];
                        [items addObject:NSLocalizedString(@"flip",nil)];
                        [items addObject:NSLocalizedString(@"mirror",nil)];
                        [items addObject:NSLocalizedString(@"flip_mirror",nil)];
                        
                        settingSheetView.checkedIndex = chn0.flipMirror;
                        break;
                    case 1:
                        //[items addObject:NSLocalizedString(@"indoor_50Hz",nil)];
                        [items addObject:NSLocalizedString(@"indoor",nil)];
                        [items addObject:NSLocalizedString(@"outdoor",nil)];
                        [items addObject:NSLocalizedString(@"night_vision",nil)];
                        
                        settingSheetView.checkedIndex = chn0.envMode;
                        break;

                    default:
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        [items addObject:NSLocalizedString(@"off",nil)];
                        [items addObject:NSLocalizedString(@"low",nil)];
                        [items addObject:NSLocalizedString(@"medium",nil)];
                        [items addObject:NSLocalizedString(@"high",nil)];
                        [items addObject:NSLocalizedString(@"max",nil)];
                        
                        settingSheetView.checkedIndex = chn0.mdSensitivity;
                        break;
#ifdef WITH_ALARM_MODE

                    case 1:
                        [items addObject:NSLocalizedString(@"alarm_silent",nil)];
                        [items addObject:NSLocalizedString(@"alarm_audio",nil)];
                        [items addObject:NSLocalizedString(@"alarm_vibrate",nil)];
                        [items addObject:NSLocalizedString(@"alarm_both",nil)];
                        
                        settingSheetView.checkedIndex = chn0.alarmMode;
                        break;
#endif
                    default:
                        break;
                }
                break;
            case 3:
                switch (indexPath.row) {
                    case 0:
                        [items addObject:NSLocalizedString(@"no_record",nil)];
                        [items addObject:NSLocalizedString(@"full_time_record",nil)];
                        [items addObject:NSLocalizedString(@"alarm_trigger_record",nil)];
                        //[items addObject:NSLocalizedString(@"manual_trigger_record",nil)];
                        settingSheetView.checkedIndex = chn0.recordMode;
                        break;
                        
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        
        settingSheetView.itemArray = items;
        newvalue = settingSheetView.checkedIndex;
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 2;
            break;
        case 2:
#ifdef WITH_ALARM_MODE
            rows = 2;
#else
            rows = 1;
#endif
            break;
        case 3:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

-(NSString *)getVideoQualiyName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"max",nil);
            break;
        case 1:
            str = NSLocalizedString(@"high",nil);
            break;
        case 2:
            str = NSLocalizedString(@"medium",nil);
            break;
        case 3:
            str = NSLocalizedString(@"low",nil);
            break;
        case 4:
            str = NSLocalizedString(@"min",nil);
            break;
        default:
            break;
    }
    return str;
}
-(NSString *)getFlipMirrorName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"normal",nil);
            break;
        case 1:
            str = NSLocalizedString(@"flip",nil);
            break;
        case 2:
            str = NSLocalizedString(@"mirror",nil);
            break;
        case 3:
            str = NSLocalizedString(@"flip_mirror",nil);
            break;
        default:
            break;
    }
    return str;
}

-(NSString *)getEnvName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"indoor",nil);
            break;
        //case 1:
        //    str = NSLocalizedString(@"indoor_60Hz",nil);

        //    break;
        case 1:
            str =NSLocalizedString(@"outdoor",nil);

            break;
        case 2:
            str = NSLocalizedString(@"night_vision",nil);

            break;
        default:
            break;
    }
    return str;
}

-(NSString *)getRecordModeName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"no_record",nil);
            break;
        case 1:
            str = NSLocalizedString(@"full_time_record",nil);
            break;
        case 2:
            str = NSLocalizedString(@"alarm_trigger_record",nil);
            break;
        case 3:
            str = NSLocalizedString(@"manual_trigger_record",nil);
            break;
        default:
            break;
    }
    return str;
}

-(NSString *)getMDSensitityName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"off",nil);

            break;
        case 1:
            str = NSLocalizedString(@"low",nil);

            break;
        case 2:
            str = NSLocalizedString(@"medium",nil);
            break;
        case 3:
            str = NSLocalizedString(@"high",nil);

            break;
        case 4:
            str = NSLocalizedString(@"max",nil);
            break;
        default:
            break;
    }
    return str;
}

-(NSString *)getAlarmModeName:(int) index{
    NSString *str;
    switch (index) {
        case 0:
            str = NSLocalizedString(@"alarm_silent",nil);
            
            break;
        case 1:
            str = NSLocalizedString(@"alarm_audio",nil);
            
            break;
        case 2:
            str = NSLocalizedString(@"alarm_vibrate",nil);
            break;
        case 3:
            str = NSLocalizedString(@"alarm_both",nil);
            break;

        default:
            break;
    }
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    UITableViewCell *cell;
    
    if(section == 0) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"AdvanceSettingSecurityCell" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvanceSettingSecurityCell"];
        }
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AdvanceSettingCell" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvanceSettingCell"];
        }
    }

    ubiaDeviceChannelSettings *chn = currentDevice.settings.chnSettings[currentDevice.client.activechn];
    if(selectCellPath != nil){
        switch (selectCellPath.section) {
            case 0:
                ;
                break;
            case 1:
                switch (selectCellPath.row) {
#if 0
                    case 0:
                        if(newvalue != chn.videoQuality){
                            //set video quality
                            chn.videoQuality = newvalue;
                            [currentDevice setVideoQuality];
                        }
                        break;
#endif
                    case 0:
                        if(newvalue != chn.flipMirror){
                            //set flipMirror
                            chn.flipMirror = newvalue;
                            [currentDevice setVideoMode];
                        }
                        break;
                    case 1:
                        if(newvalue != chn.envMode){
                            //set envMode
                            chn.envMode = newvalue;
                            [currentDevice setDeviceEnvMode];
                        }
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (selectCellPath.row) {
                    case 0:
                        if(newvalue != chn.mdSensitivity){
                            //set motion detection sensitivity
                            chn.mdSensitivity = newvalue;
                            [currentDevice setMDSensitivity];
                            
                        }
                        break;
#ifdef WITH_ALARM_MODE
                    case 1:
                        if(newvalue != chn.alarmMode){
                            //set AlarmMode
                            chn.alarmMode = newvalue;
                            [currentDevice setAlarmMode];
                        }
                        break;
#endif
                }
                break;
            case 3:
                switch (selectCellPath.row) {
                    case 0:
                        if(newvalue != chn.recordMode){
                            //set RecordMode
                            chn.recordMode = newvalue;
                            [currentDevice setRecordMode:newvalue];
                        }
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    
    switch (section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"security_code", nil);
            break;
        case 1:
            switch (row) {
#if  0
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"video_quality", nil);
                    cell.detailTextLabel.text = [self getVideoQualiyName:chn.videoQuality];
                    break;
#endif
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"mirror_flip", nil);
                    cell.detailTextLabel.text = [self getFlipMirrorName:chn.flipMirror];
                    break;
                    
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"environment_mode", nil);
                    cell.detailTextLabel.text = [self getEnvName:chn.envMode];
                    break;

                default:
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            switch (row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"motion_detection", nil);
                    cell.detailTextLabel.text = [self getMDSensitityName:chn.mdSensitivity];
                    break;
#ifdef WITH_ALARM_MODE
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"alarm_mode", nil);
                    cell.detailTextLabel.text = [self getAlarmModeName:chn.alarmMode];
                    break;
#endif
                default:
                    break;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        case 3:
            switch (row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"record_mode", nil);
                    cell.detailTextLabel.text = [self getRecordModeName:chn.recordMode];
                    break;
                default:
                    break;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
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
    selectCellPath = indexPath;
}

@end
