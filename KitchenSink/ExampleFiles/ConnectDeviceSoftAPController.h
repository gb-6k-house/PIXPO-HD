

@class ubiaRestClient;
@class ubiaDevice;
@interface ConnectDeviceSoftAPController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (weak, nonatomic) ubiaRestClient *restClient;
@property (strong, nonatomic) ubiaDevice *currentDevice;


@end
