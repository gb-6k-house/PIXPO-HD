//
//  ubiaFileQueryInfo.h
//  P4PCamLive
//
//  Created by Maxwell on 15/1/21.
//  Copyright (c) 2015年 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ubiaQueryInfo : NSObject
@property (assign,nonatomic) int        typeFilter;
@property (strong,nonatomic) NSString   * pathName;
@property (strong,nonatomic) NSDate     * startDate;
@property (strong,nonatomic) NSDate     * EndDate;

@end
