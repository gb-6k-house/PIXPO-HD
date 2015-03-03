
#import <CoreData/CoreData.h>

@class ubiaDevice;
@interface DeviceWifiAPListController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (weak, nonatomic)   NSMutableArray * aplistArray;
+ (QRootElement *)createDetailsForm;

@end
