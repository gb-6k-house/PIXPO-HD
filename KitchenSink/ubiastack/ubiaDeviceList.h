//
//  ubiaDeviceList.h
//  P4PCamLive
//
//  Created by Maxwell on 13-4-25.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ubiaDevice;
@interface ubiaDeviceList : NSObject{
    NSMutableArray *interanlSet;
}
-(id) init;
-(int) addDevice:(ubiaDevice *)device;
-(ubiaDevice *) getDeviceByUID:(NSString *) uid;
-(int) startAllDevice;
-(int) stopAllDevice;
-(int) removeDevice:(id)device;
-(int) removeDeviceByUID:(NSString *) uid;
-(int) removeAllDevice;
-(int) count;
-(ubiaDevice *) getDeviceByIndex:(int) index;

@end
