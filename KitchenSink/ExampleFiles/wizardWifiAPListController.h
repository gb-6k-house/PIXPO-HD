
#import <CoreData/CoreData.h>

@class ubiaDevice;
@interface wizardWifiAPListController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (weak, nonatomic)   NSMutableArray * aplistArray;


@end
