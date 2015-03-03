//
//  ubiaAddDeviceTableViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-12.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaAddDeviceTableViewController.h"
//#import "ubiaAddDeviceViewCell.h"
#import "ubiaLabel+TextFieldCell.h"

#import "ubiaDevice.h"

//#import "ubiaMasterViewController.h"
#import "MMExampleCenterTableViewController.h"


#import "ZBarSDK.h"

#include "IOTCAPIs.h"

@interface ubiaAddDeviceTableViewController ()

@end

@implementation ubiaAddDeviceTableViewController
@synthesize addSectionArray;
@synthesize actionSectionArray;
@synthesize searchSectionArray;
@synthesize foundDevice;
@synthesize ubiaTableView;



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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //manualArray = @[@"Name",@"UID",@"Password"];
    
    
#if 0
    ubiaDevice * device = [[ubiaDevice alloc] init];
    device.uid = @"FRW9SYR7DCSLSMXUYPCJ";
    device.ipaddr =@"192.168.0.11";
    [searchResult addObject:device];
    
    device = [[ubiaDevice alloc] init];
    device.uid = @"EBWTUKNR1PSBTNDUU65J";
    device.ipaddr =@"192.168.0.13";
    [searchResult addObject:device];
#endif
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(doBtnSearch:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    //addSectionArray = @[@"Name",@"UID",@"Password"];
    addSectionArray = @[NSLocalizedString(@"name",nil),NSLocalizedString(@"uid",nil),NSLocalizedString(@"password", nil)];
    //actionSectionArray = @[@"Add"];
    actionSectionArray = @[NSLocalizedString(@"add", nil)];
    
    searchSectionArray = [NSMutableArray arrayWithCapacity:LAN_SEARCH_MAX_NUM];
    //[searchSectionArray addObject:@"Search Result"];
    
    isSearchDoing  = FALSE;
    isSearchFinished = FALSE;
    
    //EBWTUKNR1PSBTNDUU65J
    //FRW9SYR7DCSLSMXUYPCJ
    //F7C9AHNY8WU7VM6PSFXT
    //FFMTVKPZ8P83SNDUYPYJ
    //CFGTUKNFJ68BTNXUU6D1

}

- (void) setDeviceUID:(NSString*) uid{
    if(foundDevice == nil){
        foundDevice = [[ubiaDevice alloc] init];
    }
    foundDevice.uid = uid;
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
            rows = [addSectionArray count];
            break;
        case 1:
            rows = [actionSectionArray count];
            break;
        case 2:
        {
            rows = [searchSectionArray count];
            break;
        }
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"textFieldCell";
    int section = [indexPath section];
    int row = [indexPath row];
    UITableViewCell *cell;
    
    // Configure the cell...
    switch (section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            
            if(cell == nil){
                cell =[[ubiaLabel_TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
            }
            
            ubiaLabel_TextFieldCell *ubiaCell = (ubiaLabel_TextFieldCell *)cell;
        
            ubiaCell.attrLabel.text = addSectionArray[row];
 
            if(foundDevice == nil)
                [ubiaCell.attrValue setPlaceholder:addSectionArray[row]];
            else{
                switch (row) {
                    case 0:
                        if(foundDevice.name == nil ||[foundDevice.name isEqualToString:@""]){
                            [ubiaCell.attrValue setPlaceholder:addSectionArray[row]];
                        }else{
                            ubiaCell.attrValue.text = foundDevice.name;
                        }
                        break;
                    case 1:
                        if(foundDevice.uid == nil || [foundDevice.uid isEqualToString:@""]){
                            [ubiaCell.attrValue setPlaceholder:addSectionArray[row]];
                        }else{
                            ubiaCell.attrValue.text = foundDevice.uid;
                        }
                        break;
                    case 2:
                        if(foundDevice.client.password == nil ||[foundDevice.client.password isEqualToString:@""]){
                            [ubiaCell.attrValue setPlaceholder:addSectionArray[row]];
                        }else{
                            ubiaCell.attrValue.text = foundDevice.client.password;
                        }

                        [ubiaCell.attrValue setSecureTextEntry:TRUE];
                        break;
                        
                    default:
                        break;
                }
            }

            //[ubiaCell.attrValue addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            //cell.accessoryView = ubiaCell.attrValue;

        }
            break;
 
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"btnCell" forIndexPath:indexPath];
            if(cell ==nil)
                cell =[[ubiaLabel_TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"btnCell"];
            cell.textLabel.text = actionSectionArray[row];
        }
            break;
        case 2:
        {
            if(isSearchDoing){
                cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell" forIndexPath:indexPath];
                if(cell == nil)
                {
                    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"labelCell"];
                }
                cell.textLabel.text = searchSectionArray[0];
                cell.detailTextLabel.text = @"";
                
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell" forIndexPath:indexPath];
                if(cell == nil)
                {
                    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"labelCell"];
                }
                if(0 < numofFoundDevice){
                    ubiaDevice * device = (ubiaDevice *)searchSectionArray[row];
                    cell.textLabel.text = device.uid;
                    cell.detailTextLabel.text = device.ipaddr;
                }else{
                    cell.textLabel.text = searchSectionArray[0];
                    cell.detailTextLabel.text = @"";
                }
            }
            
        }
            break;
        default:
            break;
    }

    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
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
    int section = indexPath.section;
    int row = indexPath.row;
    
    if(section == 1)
    {
        switch (row) {
            case 0:
                [self addFoundDevice];
                break;
            //case 1:
            //    [self doQRCode];
            //case  2:
            //    [self doBtnSearch:self];
            default:
                break;
        }
    }else if(section == 2){
        if(0 < numofFoundDevice){
            foundDevice = [searchSectionArray objectAtIndex:row];
        
            NSLog(@" count %d found device to [%d]:%@",[searchSectionArray count],row,foundDevice.uid);
        }
    }

    [tableView reloadData];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (IBAction)doBtnSearch:(id)sender {
    
    isSearchDoing = TRUE;
    isSearchFinished = FALSE;
    [searchSectionArray removeAllObjects];
    [searchSectionArray addObject:@"Searching..."];
    [self.ubiaTableView reloadData];
    
    memset(foundDevicelist,0,sizeof(struct st_LanSearchInfo)*LAN_SEARCH_MAX_NUM);
    [NSThread detachNewThreadSelector:@selector(doSearchBackground) toTarget:self withObject:NO];
}
- (void)doSearchBackground{
    
    numofFoundDevice = UBIC_Lan_Search(foundDevicelist,LAN_SEARCH_MAX_NUM,5000);
    //numofFoundDevice = UBIC_Lan_Search(foundDevicelist,LAN_SEARCH_MAX_NUM,5000);
    [self performSelectorOnMainThread:@selector(makeUpdateTableofFoundDevice) withObject:nil waitUntilDone:NO];
    
}

- (void)makeUpdateTableofFoundDevice {
	
	// wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
    //[NSThread sleepForTimeInterval:3];
    //[self.ubiaTableView beginUpdates];
    int i=0;
    isSearchDoing = FALSE;
    
    NSMutableArray * searchResults = [NSMutableArray arrayWithCapacity:LAN_SEARCH_MAX_NUM];
    //[searchSectionArray removeAllObjects];
    
    if(numofFoundDevice < 0) {
        NSLog(@" Lan Search err %d",numofFoundDevice);
        [searchResults addObject:@"Found 0 Device"];
    }else if(numofFoundDevice == 0){
        NSLog(@" Lan Search no device");
        [searchResults addObject:@"Found 0 Device"];

    }else{
        
        NSLog(@"got num %d",numofFoundDevice);
        
        for(i = 0;i < numofFoundDevice;i++){
            ubiaDevice *device = [[ubiaDevice alloc] init];
            device.uid = [NSString  stringWithUTF8String: foundDevicelist[i].UID];
            device.ipaddr = [ NSString stringWithUTF8String:foundDevicelist[i].IP];
            device.port = foundDevicelist[i].port;
            device.client.password = @"admin";// default value is admin
            [searchResults addObject:device];
            NSLog(@"got uid:%@",device.uid);
        }

    }
    searchSectionArray = searchResults;
    //[self.ubiaTableView endUpdates];
    [self.ubiaTableView reloadData];
}

- (void)addFoundDevice {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ubiaLabel_TextFieldCell * cell = (ubiaLabel_TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"uid :%@",cell.textLabel.text);
    NSString *uid = cell.attrValue.text;
    
 
    if(uid.length != 20){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"AddDevice"
                                                    message:@"UID shall exact be 20 Bytes" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = (ubiaLabel_TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *password = cell.attrValue.text;
    
    if([password isEqualToString:@""]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"AddDevice"
                                                    message:@"Password shall not be null" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
        return;
    }
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = (ubiaLabel_TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.attrValue.text;
    
    if(foundDevice == nil)
        foundDevice = [[ubiaDevice alloc] init];
    
    foundDevice.uid = uid;
    foundDevice.loginID = @"admin";
    foundDevice.password = password;
    foundDevice.name = name;
    foundDevice.location = @"default address";
    
    foundDevice.client.password = password;
    
    if(nil ==  foundDevice.client.loginID || [foundDevice.client.loginID isEqualToString:@""]){
        foundDevice.client.loginID = @"admin";
    }
    
    MMExampleCenterTableViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:0];
    
    [prevVC insertNewObject:foundDevice];
    
    [self.navigationController popToViewController:prevVC animated:YES];

}

@end
