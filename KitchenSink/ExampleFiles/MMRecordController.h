//
//  MMRecordControllerTableViewController.h
//  P4PLive
//
//  Created by Maxwell on 14-7-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMExampleTableViewController.h"

#import <CoreData/CoreData.h>
@class ASIHTTPRequest;

@interface MMRecordController : MMExampleTableViewController
{
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
    BOOL isPlay;
}
@end
