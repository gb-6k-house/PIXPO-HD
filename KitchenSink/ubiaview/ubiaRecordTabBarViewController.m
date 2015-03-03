//
//  ubiaRecordTabBarViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/20.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "ubiaRecordTabBarViewController.h"
#import "KxMenu.h"
#import "MMLocalRecordTableViewController.h"
#import "ubiaAlertViewController.h"
#import "MMTransferTableViewController.h"
#import "MMAppDelegate.h"

@interface ubiaRecordTabBarViewController ()
{

}
@end

@implementation ubiaRecordTabBarViewController

@synthesize deviceView,cloudview,localview;

@synthesize deviceManager;
@synthesize showByFile;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"record_tile_txt", nil);
    //[self setupRightMenuButton];
    showByFile = FALSE;
#if 0
    NSArray *array = [NSArray arrayWithObjects:NSLocalizedString(@"record_byevent_txt", nil),NSLocalizedString(@"record_byfile_txt", nil), nil];
    
    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:array];
    segmentedController.segmentedControlStyle = UISegmentedControlSegmentCenter;
    [segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedController.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = segmentedController;
#endif
    //Do any additional setup after loading the view.
    self.tabBarController.delegate = self;
    //set navigatorbar not hide tablview maxwell
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIViewController * view =  [self.viewControllers objectAtIndex:0];
    [view.tabBarItem setTitle:NSLocalizedString(@"p2_tab_device", nil)];
    view =  [self.viewControllers objectAtIndex:1];
    [view.tabBarItem setTitle:NSLocalizedString(@"p2_tab_transfer", nil)];
    view =  [self.viewControllers objectAtIndex:2];
    [view.tabBarItem setTitle:NSLocalizedString(@"p2_tab_local", nil)];
}
-(void) viewWillDisappear:(BOOL)animated{
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.deviceManager pauseAllDownloadFile];
    
    NSLog(@"%s,===>",__FUNCTION__);
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentAction:(id)sender
{
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按事件查看录像" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //[alter show];
            switch ([self.tabBarController selectedIndex]) {
                case 0:
                    [deviceView switchShowType:FALSE];
                    break;
                case 1:
                    [localview switchShowType:FALSE];
                    break;
                default:
                    break;
            }
        }
        break;
        case 1:
        {
            //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按文件查看录像" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //[alter show];
            switch ([self.tabBarController selectedIndex]) {
                case 0:
                    [deviceView switchShowType:TRUE];
                    break;
                case 1:
                    [localview switchShowType:TRUE];
                    break;
                default:
                    break;
            }
        }
        break;
        default:
        break;
    }   
}

- (void)showMenu:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_1day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(searchlast24hours)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_3day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(searchlast72hours)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_7day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(searchlastweekhours)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_all_txt", nil)
                     image:nil
                    target:self
                    action:@selector(searchall)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    UIView *targetView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    CGRect rect = targetView.frame;
    rect.origin.y -= 25;
    
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

-(void)setupRightMenuButton{
    //MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];

    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showMenu:)];
    
    //[self.navigationItem setRightBarButtonItems:segment  animated:YES];
    [self.navigationItem setRightBarButtonItem:rightBarBtn animated:YES];
    
}

- (IBAction)searchlast24hours{
    
}

- (IBAction)searchlast72hours{
    
}
- (IBAction)searchlastweekhours{
    
}
- (IBAction)searchall{
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag==1)
    {
        //your code
    }
    else
    {
        //your code
    }
}

@end
