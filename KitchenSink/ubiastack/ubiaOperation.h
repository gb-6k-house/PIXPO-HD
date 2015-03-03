//
//  ubiaOperation.h
//  P4PLive
//
//  Created by Maxwell on 14-4-16.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ubiaDevice;

@interface ubiaOperation : NSOperation

/* Designated Initializer */

- (id) initForConnect:(ubiaDevice *)device;
- (id) initForDisconnect:(ubiaDevice *)device;
- (id) initForSendIOCtrl:(ubiaDevice *)device withCmd:(int) cmd withBuf: (char *) buf withSize:(int)size;

@end
