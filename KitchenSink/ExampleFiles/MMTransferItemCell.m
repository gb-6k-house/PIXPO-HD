//
//  MMTransferItemCell.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/28.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTransferItemCell.h"
#import "ToggleButton.h"
#import "Utilities.h"
#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"

@implementation MMTransferItemCell
{
    NSString * statusString;
    NSString * speedString;
    float progress;
}

@synthesize onTransfering;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickOnStartOrPlayBtn:(ToggleButton *)sender {

    NSLog(@"Click on %d Btn",sender.tag);
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    ubiaDeviceManager * deviceManager = appDelegate.deviceManager;
    
    ubiaFileNode * fileNode = _progressView.fileNode;
    if (nil != fileNode && nil != deviceManager) {
        if (FILE_STATUS_TRANSFERING != fileNode.status){
            [deviceManager startDownLoadFile:fileNode];
            [_StartOrPauseButton setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
        }else{
            [deviceManager.currentDevice stopDownload:fileNode];
            fileNode.status = FILE_STATUS_PAUSE;
            [_StartOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }

    if (sender.on) {
        //[deviceManager resumeFileDownload:sender.tag];
        //[self.progressView play];
        self.progressView.playOrPauseButtonIsPlaying = YES;
    }else {
        //[self.progressView pause];
        //[deviceManager pauseFileDownload:sender.tag];
        self.progressView.playOrPauseButtonIsPlaying = NO;
    }
}

-(void) internalUpdateCell{

    self.TransferStatusLabel.text = statusString;
    
    self.TransferSpeedLabel.text = speedString;
    [self.progressView updateProgressCircle:progress];
    [self setNeedsDisplay];
}

-(void)downloadUpdate:(unsigned int)gotBytes total:(unsigned int)totalBytes speed:(int)speed
{
    //NSLog(@"%s, got:%u total:%u,speed:%d",__FUNCTION__, gotBytes,totalBytes,speed);
    
    statusString = [NSString stringWithFormat:@"%@/%@",[Utilities formatFileSize:(gotBytes)],[Utilities formatFileSize:totalBytes]];
    speedString = [NSString stringWithFormat:@"%@/S",[Utilities formatFileSize:speed]];
    
    progress = gotBytes * 1.0 /totalBytes;
    if (onTransfering) {
        [self performSelectorOnMainThread:@selector(internalUpdateCell) withObject:nil waitUntilDone:NO];
    }
}

@end
