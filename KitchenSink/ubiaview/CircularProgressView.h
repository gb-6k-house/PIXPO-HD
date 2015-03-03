//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//  QQ:20118368
//  http://nijino.cn

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ubiaFileNode.h"

@protocol CircularProgressViewDelegate <NSObject>

@optional

- (void)updateProgressViewWithFileNode:(ubiaFileNode *) fileInfo;
- (void)updateProgressViewWithPlayer:(AVAudioPlayer *)player;
- (void)playerDidFinishPlaying;

@end

@interface CircularProgressView : UIView

@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (copy, nonatomic) NSString *audioPath;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) BOOL playOrPauseButtonIsPlaying;
@property (assign, nonatomic) id <CircularProgressViewDelegate> delegate;

@property (strong,nonatomic) ubiaFileNode *fileNode;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
          audioPath:(NSString *)path;

- (void)play;
- (void)pause;
- (void)stop;
- (void)updateProgressCircle:(float) progress;

@end