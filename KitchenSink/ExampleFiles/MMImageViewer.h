//
//  MMImageViewer.h
//  P4PLive
//
//  Created by Maxwell on 14-5-10.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMImageViewer : UIImageView

@property (assign,nonatomic) BOOL internalVisible;

- (void)loading:(BOOL)visible;


@end
