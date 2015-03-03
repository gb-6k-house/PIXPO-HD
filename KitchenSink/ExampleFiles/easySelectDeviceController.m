

#import "MMAppDelegate.h"
#import "easySelectDeviceController.h"
#import "easyDeviceWifiConfigController.h"

#import "WifiSetupInfo.h"

#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"

#import "ubiaDeviceManager.h"
#import "ubiaDeviceList.h"

//#import <SystemConfiguration/CaptiveNetwork.h>



@interface easySelectDeviceController (){
    //int preambleIndex;
}

- (void)easySetupCameraWifi;
- (void)onNextSetupCameraWifi;
- (void)scanCameraUID;

@end

@implementation easySelectDeviceController{
    QSelectSection *simpleSelectSection;
    ubiaDeviceList * deviceList;
}
@synthesize selectUID;


- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        
        self.root.appearance = [self.root.appearance copy];

        ((QEntryElement *)[self.root elementWithKey:@"login_key"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"password_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"scan_button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"scan_button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
  
        [self.root elementWithKey:@"scan_button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        
        [self.root elementWithKey:@"next_button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"next_button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
        
        [self.root elementWithKey:@"next_button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
                
        simpleSelectSection = (QSelectSection *)[self.root sectionWithKey:@"camera_uid_list"];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        simpleSelectSection.onSelected = ^{
            NSLog(@"selected index: %@", weakSelf->simpleSelectSection.selectedItems);
            int index =  [[weakSelf->simpleSelectSection.selectedIndexes objectAtIndex:0] intValue];
            //weakSelf->selectUID = [weakSelf->simpleSelectSection.selectedItems objectAtIndex:0];
            weakSelf->selectUID = [weakSelf->deviceList getDeviceByIndex:index].uid;
            [weakSelf easySetupCameraWifi];
        };
        
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
    MMAppDelegate * delegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceList = delegate.deviceManager.restClient.myDeviceList;
    
    [self.quickDialogTableView reloadData];
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    //ubiaLabel_TextFieldCell * cell = (ubiaLabel_TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //cell.attrValue.text = symbol.data;
    
    selectUID = symbol.data;
    
    [reader dismissModalViewControllerAnimated: YES];
    
    if (selectUID.length != 20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"uid_len_invalid", nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    
    //[self performSegueWithIdentifier:@"gotoAddDevice" sender:self];

    [self easySetupCameraWifi];
}


- (void)scanCameraUID{
    // ADD: present a barcode reader that scans from the camera feed
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    ubiaRestClient * restClient = appDelegate.deviceManager.restClient;
    
    if (!([restClient.myDeviceList count] < MAX_SESSION)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"reach_max_device", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    //[self presentModalViewController: reader animated: YES];
    [self presentViewController: reader animated:YES completion:(void (^)(void))nil];
}

- (void)onNextSetupCameraWifi{
    WifiSetupInfo *info = [[WifiSetupInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    ubiaRestClient * restClient = appDelegate.deviceManager.restClient;
    
    if (!([restClient.myDeviceList count] < MAX_SESSION)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"reach_max_device", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (info.uid != nil && [info.uid length] > 0) {
        //update user input
        if ([info.uid length] != UID_SIZE) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"uid_len_invalid",nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            [alert show];
            return;
        }
        selectUID = [info.uid uppercaseString];
        [self easySetupCameraWifi];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"uid_no_input",nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;

    }
    
}

- (void)easySetupCameraWifi {
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"easy_setup_step2_txt", nil);
    root.grouped = YES;
    root.controllerName = @"easyDeviceWifiConfigController";
    
    QSection *section0 = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section0.title = NSLocalizedString(@"easy_selected_uid_txt", nil);
    //section.headerImage = @"logo";
    section0.footer = @"";
    
    QEntryElement *uidEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"uid", nil) Value:selectUID Placeholder:NSLocalizedString(@"uid", nil)];
    
    uidEntry.key = @"device_uid";
    uidEntry.bind=@"textValue:uid";
    
    [section0 addElement: uidEntry];
    [root addSection: section0];
    
    QSection *section = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section.title = NSLocalizedString(@"easy_input_wifi_key_txt", nil);
    //section.headerImage = @"logo";
    section.footer = @"";
    
    QEntryElement *ssidEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"ap_ssid", nil) Value:@"" Placeholder:NSLocalizedString(@"ap_ssid", nil)];
    
    ssidEntry.key = @"ap_ssid";
    ssidEntry.bind=@"textValue:ssid";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"ap_key", nil) Value:@"" Placeholder:NSLocalizedString(@"ap_key", nil)];
    pwdEntry.bind=@"textValue:key";
    pwdEntry.key = @"ap_key";
    pwdEntry.secureTextEntry = true;
    
    [section addElement:ssidEntry];
    [section addElement:pwdEntry];
    [root addSection:section];
    
    QSection *section1 = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"easy_setup_apply_txt", nil)];
    myGetButton.controllerAction = @"onSetWifiAPConfig:";
    myGetButton.key = @"set_button_key";
    
    [section1 addElement:myGetButton];
    
    [root addSection:section1];

    easyDeviceWifiConfigController * destViewController = (easyDeviceWifiConfigController * )[QuickDialogController controllerForRoot:root];
    
    destViewController.deviceUID = selectUID;
    if(selectUID == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                            message:NSLocalizedString(@"ui_info_no_selectuid", nil)
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
        [alert show];
        return;
    }

    [self.navigationController pushViewController:destViewController animated:YES];
}


- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    //NSLog(@"Editing changed");
}

- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");

}

@end
