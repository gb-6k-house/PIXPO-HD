
@class ubiaRestClient;
@class ubiaDevice;
@class ubiaWifiApInfo;
@interface wizardSetupDeviceWifiConfigController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (weak, nonatomic) ubiaWifiApInfo * selectedAPInfo;


@end
