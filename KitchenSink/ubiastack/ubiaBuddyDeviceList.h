//
//  ubiaBuddyList.h
//  P4PLive
//
//  Created by Maxwell on 14-8-12.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ubiaBuddy;

@interface ubiaBuddyDeviceList : NSObject{
    NSMutableArray *interanlSet;
}

-(id) init;
-(int) addDevice:(NSString *)uid;
-(int) removeDevice:(NSString *) uid;
-(int) removeAllDevice;
-(int) count;

@end
