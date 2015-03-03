
@class ubiaRestClient;

@interface AccountSecurityController : QuickDialogController <QuickDialogEntryElementDelegate> {

}

@property (weak, nonatomic) ubiaRestClient *restClient;
@property (strong, nonatomic) UIImage * leftBarimage;


@end
