//
//  ubiaBuddy.h
//  P4PLive
//
//  Created by Maxwell on 14-8-12.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ubiaBuddyDeviceList;

@interface ubiaBuddy : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, retain) ubiaBuddyDeviceList *buddyDeviceList;

@end
