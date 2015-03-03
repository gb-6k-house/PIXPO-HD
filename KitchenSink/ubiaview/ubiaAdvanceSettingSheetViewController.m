//
//  ubiaAdvanceSettingSheetViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-6-14.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import "ubiaAdvanceSettingSheetViewController.h"
#import "ubiaDeviceAdvanceSettingViewController.h"

@interface ubiaAdvanceSettingSheetViewController ()

@end

@implementation ubiaAdvanceSettingSheetViewController
@synthesize itemArray, valueArray;
@synthesize checkedIndex;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Configure the cell...
    int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"advanceSettingSheetCell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"advanceSettingSheetCell"];
    }
    // Configure the cell...
    cell.textLabel.text = itemArray[row];
    
    if([valueArray count] > row){
        cell.detailTextLabel.text = valueArray[row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(row == checkedIndex) cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
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
    checkedIndex = indexPath.row;
    [tableView reloadData];
    int num = [self.navigationController.viewControllers count];
    ubiaDeviceAdvanceSettingViewController  *prevVC = [self.navigationController.viewControllers objectAtIndex:num-2];
    prevVC.newvalue = checkedIndex;
    [prevVC.tableView reloadData];
    [self.navigationController popToViewController:prevVC animated:YES];
}

@end
