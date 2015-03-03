//
//  MMExampleTableViewController.m
//  MMDrawerControllerKitchenSink
//
//  Created by Maxwell on 13-10-20.
//  Copyright (c) 2013年 UBIA. All rights reserved.
//

#import "MMExampleTableViewController.h"

#import "Utilities.h"

@interface MMExampleTableViewController ()

@end

@implementation MMExampleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    //[self beginAppearanceTransition: YES animated: animated];
    [super viewWillAppear:animated];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[self beginAppearanceTransition: NO animated: animated];
    [super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    //[self endAppearanceTransition];
    [super viewDidAppear:animated];
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
    
    //UIView *backView = [[UIView alloc] init];
    
    //UIColor * color = [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
    
    //UIColor * color = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
    
    //[backView setBackgroundColor:color];
    
    //[self.tableView setBackgroundView:backView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

-(void)contentSizeDidChange:(NSString *)size{
    //Implement in subclass
    NSLog(@"contentSizeDidChange :%@",size);
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: nil forIndexPath:indexPath];
    

    // Configure the cell...
    
    return cell;
}

#if 0
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"=====willDisplayCell [%d:%d]", indexPath.section,indexPath.row);
    for (UITableViewCell *visiblecell in tableView.visibleCells) {
        NSIndexPath *index = [tableView indexPathForCell:visiblecell];
        NSLog(@"  visible cell [%d:%d]", index.section,index.row);
    }

}
#endif
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
