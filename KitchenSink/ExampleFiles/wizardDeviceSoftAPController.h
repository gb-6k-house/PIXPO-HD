

@class ubiaRestClient;
@class ubiaDevice;
@interface wizardDeviceSoftAPController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (weak, nonatomic) ubiaRestClient *restClient;
@property (strong, nonatomic) ubiaDevice *currentDevice;


@end
