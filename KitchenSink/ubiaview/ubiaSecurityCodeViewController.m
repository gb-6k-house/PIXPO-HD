//
//  ubiaSecurityCodeViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-6-27.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import "ubiaSecurityCodeViewController.h"
#import "ubiaSecurityCodeCell.h"
#import "ubiaDevice.h"

@interface ubiaSecurityCodeViewController ()

@end

@implementation ubiaSecurityCodeViewController

@synthesize oldpassword;
@synthesize currentDevice;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    int section = [indexPath section];
    int row = [indexPath row];
    UITableViewCell *cell;
    
    // Configure the cell...
    switch (section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"securityCodeTextCell" forIndexPath:indexPath];
            
            if(cell == nil){
                cell =[[ubiaSecurityCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"securityCodeTextCell"];
            }
            
            ubiaSecurityCodeCell *ubiaCell = (ubiaSecurityCodeCell *)cell;
            switch (row)
            {
                //case 0:
                //    ubiaCell.attrName.text = NSLocalizedString(@"old_password",nil);

                //    break;
                case 0:
                    ubiaCell.attrName.text = NSLocalizedString(@"new_password",nil);
                    break;
                case 1:
                    ubiaCell.attrName.text = NSLocalizedString(@"retry_password",nil);

                    break;
                default:
                    break;
            }
            ubiaCell.attrValue.secureTextEntry = TRUE;
            
            break;
        }
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"securityCodeActionCell" forIndexPath:indexPath];
            
            if(cell == nil){
                cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"securityCodeActionCell"];
            }
            cell.textLabel.text = NSLocalizedString(@"apply", nil);//@"Apply";
            
            break;
    }
    // Configure the cell...
    
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
    
    int section  = [indexPath section];
    int row = [indexPath row];
    
    if(section == 1 && row == 0){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ubiaSecurityCodeCell * cell = (ubiaSecurityCodeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *newpassword = cell.attrValue.text;
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = (ubiaSecurityCodeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *retrypassword = cell.attrValue.text;

        //indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //cell = (ubiaSecurityCodeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        oldpassword = currentDevice.client.password;
        
#if 0
        oldpassword = cell.attrValue.text;
        if( oldpassword == nil || [oldpassword isEqualToString:@""]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Change Security Code"
                                                        message:@"Please input old password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
            return;
        }
#endif
        
        if (newpassword == nil || [newpassword isEqualToString:@""]) {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle: nil
                                                        message: NSLocalizedString(@"device_password_isnull", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
            return;
        }else{
        
            if([newpassword isEqual:retrypassword]){
                [currentDevice setPassword:newpassword withOldPassword:oldpassword];
                
                
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle: nil
                                                            message: NSLocalizedString(@"device_password_change_ok", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
                return;
                
                //NSArray *myKeys = [NSArray arrayWithObjects:@"ubiaDevice",nil];
                
                //NSArray *myObjects = [NSArray arrayWithObjects: currentDevice,nil];
                //NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
                
                //[[NSNotificationCenter defaultCenter] postNotificationName: @"ubiaMasterViewNotification" object:nil userInfo: myTestDictionary];
                
            }else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"device_password_mismatch", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
                return;
            }
        }

        
    }
}

@end
