//
//  ubiaBuddyList.h
//  P4PLive
//
//  Created by Maxwell on 14-8-17.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ubiaBuddy;

@interface ubiaBuddyList : NSObject{
   NSMutableArray *interanlSet;
}

-(id) init;
-(int) addBuddy:(NSString *)webaccount;
-(int) removeBuddy:(NSString *) webaccount;
-(int) removeAllBuddy;
-(int) count;

@end
