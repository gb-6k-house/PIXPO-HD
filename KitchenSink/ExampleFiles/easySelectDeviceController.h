
#import "ZBarSDK.h"

@class ubiaDevice;
@class ubiaDeviceList;

@interface easySelectDeviceController : QuickDialogController <QuickDialogEntryElementDelegate,ZBarReaderDelegate> {

}

@property (strong, nonatomic) NSString *selectUID;

- (void)scanCameraUID;
- (void)easySetupCameraWifi;
- (void)onNextSetupCameraWifi;
@end
