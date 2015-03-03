
@class ubiaRestClient;
@class ubiaDevice;
@class ubiaWifiApInfo;
@interface setupDeviceWifiConfigController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (weak, nonatomic) ubiaWifiApInfo * selectedAPInfo;
+ (QRootElement *)createDetailsForm;

@end
