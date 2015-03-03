//
//  ubiaFileNode.h
//  P4PLive
//
//  Created by Maxwell on 14-3-31.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    FILE_STATUS_PENDING,
    FILE_STATUS_TRANSFERING,
    FILE_STATUS_PAUSE,
    FILE_STATUS_COMPLETE
};

@protocol FileNodeDelegate  <NSObject>

@optional
-(void)downloadUpdate:(unsigned int)gotBytes total:(unsigned int)totalBytes speed:(int)speed;
-(void)uploadUpdate:(unsigned int)sentBytes total:(unsigned int)totalBytes speed:(int)speed;

@end

@protocol FileNodeDelegate;



//  FileServer
//  同时允许在线client数（N），也即Session的个数,缺省值4
//  允许每个Client可以同时下载的文件个数（K）,缺省值4
//  允许每个正在下载的文件最大可分Segment的个数（S）,缺省值4
//  总共需要最大文件传输通道个数 (N * K * S)
//  总共AVID个数为 4 * N + (N * K * S) 缺省值80

#define UBIA_FILE_MAGIC_SYMBOL  0x7f2e8d06
#define UBIA_FILE_CHECKSUM_SIZE 32
#define UBIA_FILE_TMP_EXT ".utmp"

@interface ubiaFileNode : NSObject
@property (nonatomic,assign) id <FileNodeDelegate> delegate;

@property (nonatomic, assign) int subDirType;
//maybe uid for downloading
@property (nonatomic, strong) NSString * pathName;
@property (nonatomic, strong) NSString * fileName;

@property (nonatomic, assign) unsigned int filesize;
@property (nonatomic, assign) unsigned int createtime;
@property (nonatomic, assign) unsigned int updatetime;

@property (nonatomic,assign) unsigned char isDir;
@property (nonatomic,assign) unsigned char status;

@property (nonatomic,assign) unsigned char trans_channel;
@property (nonatomic,assign) unsigned char trans_avid;

@property (nonatomic,assign) unsigned int  pktsize;
@property (nonatomic,assign) unsigned int  pktnum;
@property (nonatomic,assign) unsigned int  gotpktnum;
@property (nonatomic,assign) unsigned int  duppktnum;

@property (nonatomic,assign) char  isExpandCell;
@property (nonatomic,assign) char  hasExpanded;

@property (nonatomic,assign) unsigned int  transferspeed;
//the ack BeginPktSeq
@property (nonatomic,assign) unsigned int  BeginPktSeq;
@property (nonatomic,assign) unsigned int  LastPktSeq;
@property (nonatomic,strong) NSData *recvBitmap;
@property (nonatomic,strong) NSData *md5sum;
@property (nonatomic,strong) NSFileHandle * fileHandle;

-(BOOL)initBitmap: (unsigned int) pktseq;
-(BOOL)checkBitmap: (unsigned int) pktseq;
-(void)setBitmap: (unsigned int) pktseq;

-(void)createFile:(unsigned int) size pktSize:(unsigned int) pktSize withType:(int) dirType;
-(void)writeDatatoFile:(NSData *) pktData pktSeq:(unsigned int) pktseq;
-(void)finishFile;

-(BOOL)readTransferDatafromFile;
-(BOOL)saveTransferDatatoFile;

-(void) updateBeginPktSeq;
-(void) updateStatus:(int) speed;

@end
