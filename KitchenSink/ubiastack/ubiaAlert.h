//
//  ubiaAlert.h
//  P4PCamLive
//
//  Created by Maxwell on 13-4-20.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ubiaAlert : NSObject
@property (nonatomic, assign) short year;
@property (nonatomic, assign) UInt8 month;
@property (nonatomic, assign) UInt8 day;
@property (nonatomic, assign) UInt8 hour;
@property (nonatomic, assign) UInt8 minute;
@property (nonatomic, assign) UInt8 second;

@property (nonatomic, assign) UInt8 type;
@property (nonatomic, assign) UInt8 status;
@property (nonatomic, assign) UInt16 index;
@end
