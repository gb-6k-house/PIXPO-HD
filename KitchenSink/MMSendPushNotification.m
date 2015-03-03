//
//  MMSendPushNotification.m
//  P4PLive
//
//  Created by Maxwell on 14-4-6.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMSendPushNotification.h"
#import "SVHTTPRequest.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "Hmac_sha1.h"
#import "ubiaRestClient.h"
#import "Utilities.h"

@implementation MMSendPushNotification

#define BPUSH_P4PLIVE_API_KEY "giElWsSGjjOHcP0ZWrDRM2CW"
#define BPUSH_P4PLIVE_SECRET_KEY "AuAlr92Sq2gIfhTtbV54hkNjzXKheZCt"

char* gen_timestring(char* string)
{
    time_t timep;
    struct tm* pTime=NULL;
    
    time(&timep);
    pTime = localtime(&timep);
    
    sprintf(string,"%04d%02d%02dT%02d%02d%02d",
            pTime->tm_year+1900,
            pTime->tm_mon+1,
            pTime->tm_mday,
            pTime->tm_hour,
            pTime->tm_min,
            pTime->tm_sec);
    
    return string;
}

/*
 * MD5C.C - RSA Data Security, Inc., MD5 message-digest algorithm
 */

/*
 * Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All rights
 * reserved.
 *
 * License to copy and use this software is granted provided that it is
 * identified as the "RSA Data Security, Inc. MD5 Message-Digest Algorithm"
 * in all material mentioning or referencing this software or this function.
 *
 * License is also granted to make and use derivative works provided that such
 * works are identified as "derived from the RSA Data Security, Inc. MD5
 * Message-Digest Algorithm" in all material mentioning or referencing the
 * derived work.
 *
 * RSA Data Security, Inc. makes no representations concerning either the
 * merchantability of this software or the suitability of this software for
 * any particular purpose. It is provided "as is" without express or implied
 * warranty of any kind.
 *
 * These notices must be retained in any copies of any part of this
 * documentation and/or software.
 */

/*
 * Constants for MD5Transform routine.
 */

typedef unsigned UNSIGNED32;

/* Definitions of _ANSI_ARGS and EXTERN that will work in either
 C or C++ code:
 */
#undef _ANSI_ARGS_
#if ((defined(__STDC__) || defined(SABER)) && !defined(NO_PROTOTYPE)) || defined(__cplusplus) || defined(USE_PROTOTYPE)
#   define _ANSI_ARGS_(x)       x
#else
#   define _ANSI_ARGS_(x)       ()
#endif
#ifdef __cplusplus
#   define EXTERN extern "C"
#else
#   define EXTERN extern
#endif

/* MD5 context. */
typedef struct MD5Context {
    UNSIGNED32 state[4];	/* state (ABCD) */
    UNSIGNED32 count[2];	/* number of bits, modulo 2^64 (lsb first) */
    unsigned char buffer[64];	/* input buffer */
} ourMD5_CTX;

#define S11 7
#define S12 12
#define S13 17
#define S14 22
#define S21 5
#define S22 9
#define S23 14
#define S24 20
#define S31 4
#define S32 11
#define S33 16
#define S34 23
#define S41 6
#define S42 10
#define S43 15
#define S44 21

static unsigned char PADDING[64] = {
	0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

/*
 * F, G, H and I are basic MD5 functions.
 */
#define F(x, y, z) (((x) & (y)) | ((~x) & (z)))
#define G(x, y, z) (((x) & (z)) | ((y) & (~z)))
#define H(x, y, z) ((x) ^ (y) ^ (z))
#define I(x, y, z) ((y) ^ ((x) | (~z)))

/*
 * ROTATE_LEFT rotates x left n bits.
 */
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))

/*
 * FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4. Rotation is
 * separate from addition to prevent recomputation.
 */
#define FF(a, b, c, d, x, s, ac) { \
(a) += F ((b), (c), (d)) + (x) + (UNSIGNED32)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define GG(a, b, c, d, x, s, ac) { \
(a) += G ((b), (c), (d)) + (x) + (UNSIGNED32)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define HH(a, b, c, d, x, s, ac) { \
(a) += H ((b), (c), (d)) + (x) + (UNSIGNED32)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define II(a, b, c, d, x, s, ac) { \
(a) += I ((b), (c), (d)) + (x) + (UNSIGNED32)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}

/*
 * Encodes input (UNSIGNED32) into output (unsigned char). Assumes len is a
 * multiple of 4.
 */
static void
Encode(unsigned char *output, UNSIGNED32 * input, unsigned int len)
{
	unsigned int    i, j;
    
#if 0
	assert((len % 4) == 0);
#endif
    
	for (i = 0, j = 0; j < len; i++, j += 4) {
		output[j] = (unsigned char) (input[i] & 0xff);
		output[j + 1] = (unsigned char) ((input[i] >> 8) & 0xff);
		output[j + 2] = (unsigned char) ((input[i] >> 16) & 0xff);
		output[j + 3] = (unsigned char) ((input[i] >> 24) & 0xff);
	}
}

/*
 * Decodes input (unsigned char) into output (UNSIGNED32). Assumes len is a
 * multiple of 4.
 */
static void
Decode(UNSIGNED32 * output, unsigned char const *input, unsigned int len)
{
	unsigned int    i, j;
    
	for (i = 0, j = 0; j < len; i++, j += 4)
		output[i] = ((UNSIGNED32) input[j]) | (((UNSIGNED32) input[j + 1]) << 8) |
        (((UNSIGNED32) input[j + 2]) << 16) | (((UNSIGNED32) input[j + 3]) << 24);
}

/*
 * MD5 basic transformation. Transforms state based on block.
 */
static void
MD5Transform(UNSIGNED32 state[4], const unsigned char block[64])
{
    UNSIGNED32 a = state[0], b = state[1], c = state[2], d = state[3], x[16];
    
	Decode(x, block, 64);
    
	/* Round 1 */
	FF(a, b, c, d, x[0], S11, 0xd76aa478);	/* 1 */
	FF(d, a, b, c, x[1], S12, 0xe8c7b756);	/* 2 */
	FF(c, d, a, b, x[2], S13, 0x242070db);	/* 3 */
	FF(b, c, d, a, x[3], S14, 0xc1bdceee);	/* 4 */
	FF(a, b, c, d, x[4], S11, 0xf57c0faf);	/* 5 */
	FF(d, a, b, c, x[5], S12, 0x4787c62a);	/* 6 */
	FF(c, d, a, b, x[6], S13, 0xa8304613);	/* 7 */
	FF(b, c, d, a, x[7], S14, 0xfd469501);	/* 8 */
	FF(a, b, c, d, x[8], S11, 0x698098d8);	/* 9 */
	FF(d, a, b, c, x[9], S12, 0x8b44f7af);	/* 10 */
	FF(c, d, a, b, x[10], S13, 0xffff5bb1);	/* 11 */
	FF(b, c, d, a, x[11], S14, 0x895cd7be);	/* 12 */
	FF(a, b, c, d, x[12], S11, 0x6b901122);	/* 13 */
	FF(d, a, b, c, x[13], S12, 0xfd987193);	/* 14 */
	FF(c, d, a, b, x[14], S13, 0xa679438e);	/* 15 */
	FF(b, c, d, a, x[15], S14, 0x49b40821);	/* 16 */
    
	/* Round 2 */
	GG(a, b, c, d, x[1], S21, 0xf61e2562);	/* 17 */
	GG(d, a, b, c, x[6], S22, 0xc040b340);	/* 18 */
	GG(c, d, a, b, x[11], S23, 0x265e5a51);	/* 19 */
	GG(b, c, d, a, x[0], S24, 0xe9b6c7aa);	/* 20 */
	GG(a, b, c, d, x[5], S21, 0xd62f105d);	/* 21 */
	GG(d, a, b, c, x[10], S22, 0x2441453);	/* 22 */
	GG(c, d, a, b, x[15], S23, 0xd8a1e681);	/* 23 */
	GG(b, c, d, a, x[4], S24, 0xe7d3fbc8);	/* 24 */
	GG(a, b, c, d, x[9], S21, 0x21e1cde6);	/* 25 */
	GG(d, a, b, c, x[14], S22, 0xc33707d6);	/* 26 */
	GG(c, d, a, b, x[3], S23, 0xf4d50d87);	/* 27 */
	GG(b, c, d, a, x[8], S24, 0x455a14ed);	/* 28 */
	GG(a, b, c, d, x[13], S21, 0xa9e3e905);	/* 29 */
	GG(d, a, b, c, x[2], S22, 0xfcefa3f8);	/* 30 */
	GG(c, d, a, b, x[7], S23, 0x676f02d9);	/* 31 */
	GG(b, c, d, a, x[12], S24, 0x8d2a4c8a);	/* 32 */
    
	/* Round 3 */
	HH(a, b, c, d, x[5], S31, 0xfffa3942);	/* 33 */
	HH(d, a, b, c, x[8], S32, 0x8771f681);	/* 34 */
	HH(c, d, a, b, x[11], S33, 0x6d9d6122);	/* 35 */
	HH(b, c, d, a, x[14], S34, 0xfde5380c);	/* 36 */
	HH(a, b, c, d, x[1], S31, 0xa4beea44);	/* 37 */
	HH(d, a, b, c, x[4], S32, 0x4bdecfa9);	/* 38 */
	HH(c, d, a, b, x[7], S33, 0xf6bb4b60);	/* 39 */
	HH(b, c, d, a, x[10], S34, 0xbebfbc70);	/* 40 */
	HH(a, b, c, d, x[13], S31, 0x289b7ec6);	/* 41 */
	HH(d, a, b, c, x[0], S32, 0xeaa127fa);	/* 42 */
	HH(c, d, a, b, x[3], S33, 0xd4ef3085);	/* 43 */
	HH(b, c, d, a, x[6], S34, 0x4881d05);	/* 44 */
	HH(a, b, c, d, x[9], S31, 0xd9d4d039);	/* 45 */
	HH(d, a, b, c, x[12], S32, 0xe6db99e5);	/* 46 */
	HH(c, d, a, b, x[15], S33, 0x1fa27cf8);	/* 47 */
	HH(b, c, d, a, x[2], S34, 0xc4ac5665);	/* 48 */
    
	/* Round 4 */
	II(a, b, c, d, x[0], S41, 0xf4292244);	/* 49 */
	II(d, a, b, c, x[7], S42, 0x432aff97);	/* 50 */
	II(c, d, a, b, x[14], S43, 0xab9423a7);	/* 51 */
	II(b, c, d, a, x[5], S44, 0xfc93a039);	/* 52 */
	II(a, b, c, d, x[12], S41, 0x655b59c3);	/* 53 */
	II(d, a, b, c, x[3], S42, 0x8f0ccc92);	/* 54 */
	II(c, d, a, b, x[10], S43, 0xffeff47d);	/* 55 */
	II(b, c, d, a, x[1], S44, 0x85845dd1);	/* 56 */
	II(a, b, c, d, x[8], S41, 0x6fa87e4f);	/* 57 */
	II(d, a, b, c, x[15], S42, 0xfe2ce6e0);	/* 58 */
	II(c, d, a, b, x[6], S43, 0xa3014314);	/* 59 */
	II(b, c, d, a, x[13], S44, 0x4e0811a1);	/* 60 */
	II(a, b, c, d, x[4], S41, 0xf7537e82);	/* 61 */
	II(d, a, b, c, x[11], S42, 0xbd3af235);	/* 62 */
	II(c, d, a, b, x[2], S43, 0x2ad7d2bb);	/* 63 */
	II(b, c, d, a, x[9], S44, 0xeb86d391);	/* 64 */
    
	state[0] += a;
	state[1] += b;
	state[2] += c;
	state[3] += d;
    
	/*
	 * Zeroize sensitive information.
	 */
	memset((unsigned char *) x, 0, sizeof(x));
}

/**
 * our_MD5Init:
 * @context: MD5 context to be initialized.
 *
 * Initializes MD5 context for the start of message digest computation.
 **/
void
our_MD5Init(ourMD5_CTX * context)
{
	context->count[0] = context->count[1] = 0;
	/* Load magic initialization constants.  */
	context->state[0] = 0x67452301;
	context->state[1] = 0xefcdab89;
	context->state[2] = 0x98badcfe;
	context->state[3] = 0x10325476;
}

/**
 * ourMD5Update:
 * @context: MD5 context to be updated.
 * @input: pointer to data to be fed into MD5 algorithm.
 * @inputLen: size of @input data in bytes.
 *
 * MD5 block update operation. Continues an MD5 message-digest operation,
 * processing another message block, and updating the context.
 **/

void
ourMD5Update(ourMD5_CTX * context, const unsigned char *input, unsigned int inputLen)
{
	unsigned int    i, index, partLen;
    
	/* Compute number of bytes mod 64 */
	index = (unsigned int) ((context->count[0] >> 3) & 0x3F);
    
	/* Update number of bits */
	if ((context->count[0] += ((UNSIGNED32) inputLen << 3)) < ((UNSIGNED32) inputLen << 3)) {
		context->count[1]++;
	}
	context->count[1] += ((UNSIGNED32) inputLen >> 29);
    
	partLen = 64 - index;
    
	/* Transform as many times as possible.  */
	if (inputLen >= partLen) {
		memcpy((unsigned char *) & context->buffer[index], (unsigned char *) input, partLen);
		MD5Transform(context->state, context->buffer);
        
		for (i = partLen; i + 63 < inputLen; i += 64) {
			MD5Transform(context->state, &input[i]);
		}
		index = 0;
	} else {
		i = 0;
	}
	/* Buffer remaining input */
	if ((inputLen - i) != 0) {
		memcpy((unsigned char *) & context->buffer[index], (unsigned char *) & input[i], inputLen - i);
	}
}

/**
 * our_MD5Final:
 * @digest: 16-byte buffer to write MD5 checksum.
 * @context: MD5 context to be finalized.
 *
 * Ends an MD5 message-digest operation, writing the the message
 * digest and zeroing the context.  The context must be initialized
 * with our_MD5Init() before being used for other MD5 checksum calculations.
 **/

void
our_MD5Final(unsigned char digest[16], ourMD5_CTX * context)
{
	unsigned char   bits[8];
	unsigned int    index, padLen;
    
	/* Save number of bits */
	Encode(bits, context->count, 8);
    
	/*
	 * Pad out to 56 mod 64.
	 */
	index = (unsigned int) ((context->count[0] >> 3) & 0x3f);
	padLen = (index < 56) ? (56 - index) : (120 - index);
	ourMD5Update(context, PADDING, padLen);
    
	/* Append length (before padding) */
	ourMD5Update(context, bits, 8);
	/* Store state in digest */
	Encode(digest, context->state, 16);
    
	/*
	 * Zeroize sensitive information.
	 */
	memset((unsigned char *) context, 0, sizeof(*context));
}

#ifndef BUFSIZ //pocket pc
#define BUFSIZ 255
#endif
#define LENGTH 16


char *
our_MD5End(ourMD5_CTX *ctx, char *buf)
{
    int i;
    unsigned char digest[LENGTH];
    static const char hex[]="0123456789abcdef";
    
    if (!buf)
        buf = (char*)malloc(2*LENGTH + 1);
    if (!buf)
    	return 0;
    our_MD5Final(digest, ctx);
    for (i = 0; i < LENGTH; i++) {
        buf[i+i] = hex[digest[i] >> 4];
        buf[i+i+1] = hex[digest[i] & 0x0f];
    }
    buf[i+i] = '\0';
    return buf;
}

char *
our_MD5End_(ourMD5_CTX *ctx, char *buf)
{
    if (!buf)
        buf = (char*)malloc(2*LENGTH + 1);
    if (!buf)
    	return 0;
    our_MD5Final((unsigned char *)buf, ctx);
    return buf;
}


char *
our_MD5File(const char *filename, char *buf)
{
    unsigned char buffer[BUFSIZ];
    ourMD5_CTX ctx;
    int i;
	FILE* f;
    
    our_MD5Init(&ctx);
    f = fopen(filename, "r");
    if (f == NULL) return 0;
    while ((i = fread(buffer,1,sizeof buffer,f)) > 0) {
        ourMD5Update(&ctx,buffer,i);
    }
    fclose(f);
    if (i < 0) return 0;
    return our_MD5End(&ctx, buf);
}

char *
our_MD5Data (const unsigned char *data, unsigned int len, char *buf)
{
    ourMD5_CTX ctx;
    
    our_MD5Init(&ctx);
    ourMD5Update(&ctx,data,len);
    return our_MD5End(&ctx, buf);
}

char *
our_MD5Data_(const unsigned char *data, unsigned int len, char *buf)
{
    ourMD5_CTX ctx;
    
    our_MD5Init(&ctx);
    ourMD5Update(&ctx,data,len);
    return our_MD5End_(&ctx, buf);
}


static
void dump(const char *text,
          FILE *stream, unsigned char *ptr, size_t size,
          char nohex)
{
    size_t i;
    size_t c;
    
    unsigned int width=0x10;
    
    if(nohex)
    /* without the hex output, we can fit more on screen */
        width = 0x40;
    
    fprintf(stream, "%s, %10.10ld bytes (0x%8.8lx)\n",
            text, (long)size, (long)size);
    
    for(i=0; i<size; i+= width) {
        
        fprintf(stream, "%4.4lx: ", (long)i);
        
        if(!nohex) {
            /* hex not disabled, show it */
            for(c = 0; c < width; c++)
                if(i+c < size)
                    fprintf(stream, "%02x ", ptr[i+c]);
                else
                    fputs("   ", stream);
        }
        
        for(c = 0; (c < width) && (i+c < size); c++) {
            /* check for 0D0A; if found, skip past and start a new line of output */
            if (nohex && (i+c+1 < size) && ptr[i+c]==0x0D && ptr[i+c+1]==0x0A) {
                i+=(c+2-width);
                break;
            }
            fprintf(stream, "%c",
                    (ptr[i+c]>=0x20) && (ptr[i+c]<0x80)?ptr[i+c]:'.');
            /* check again for 0D0A, to avoid an extra \n if it's at width */
            if (nohex && (i+c+2 < size) && ptr[i+c+1]==0x0D && ptr[i+c+2]==0x0A) {
                i+=(c+3-width);
                break;
            }
        }
        fputc('\n', stream); /* newline */
    }
    fflush(stream);
}

+(void) do_baidu_push_ios:(NSString *) uid
{
	char message[1024]={0};
	char encode_message[1024]={0};
	char msg_keys[128]={0};
	char md5_string[2*1024]={0};
	char md5_urlencode_string[2*1024]={0};
	char md5[64]={0};
	char post_message[2*1024]={0};
	char post_message_body[2*1024]={0};
	time_t curtime=time(NULL);
	char timestring[128]={0};
    
	char alarminfo[128] = {0};//ethanluo
	
    //GetIosAlarmInfo(alarminfo, sizeof(alarminfo));//ethanluo
    
	/*∆¥Ω”–Ë“™…œ¥´µƒmessage*/
#if 1
	sprintf(message, "{\"aps\":{\"alert\":\"%s\",\"sound\":\"\"},\"device\":\"%s\",\"time\":\"%s\"}", \
	        alarminfo,  [uid UTF8String], \
			gen_timestring(timestring));
#else
	sprintf(message, "{\"aps\":{\"alert\":\"%s-%s\",\"sound\":\"\"},\"device\":\"%s\",\"time\":\"%s\"}", \
	        BAIDU_PUSH_TITLE, g_para.username, g_para.uid, \
			gen_timestring(timestring));
#endif
    
	URLEncode(message, strlen(message), encode_message, sizeof(encode_message));
	URLEncode("testkey", strlen("testkey"), msg_keys, sizeof(msg_keys));
    
	sprintf(md5_string, "POSThttp://channel.api.duapp.com/rest/2.0/channel/channel"
            "apikey=%s"
            //"channel_id=4202405382155967291"
            "deploy_status=2"
            "device_type=4"
            "message_type=1"
            "messages=%s"
            "method=push_msg"
            "msg_keys=%s"
            "push_type=2"
            "tag=%s"
            "timestamp=%d"
            //"user_id=1881857505"
            "%s",
            BPUSH_P4PLIVE_API_KEY, message, msg_keys, [uid UTF8String], (int)curtime, BPUSH_P4PLIVE_SECRET_KEY);
	
	URLEncode(md5_string, strlen(md5_string), md5_urlencode_string, sizeof(md5_urlencode_string));

    our_MD5Data((const unsigned char *)md5_urlencode_string, strlen(md5_urlencode_string), md5);
    
    //CC_MD5((unsigned char*)md5_urlencode_string, strlen(md5_urlencode_string), (unsigned char *)md5);
	
    
	sprintf(post_message_body,
			"apikey=%s&"
			"sign=%s&"
			//"channel_id=4202405382155967291&"
			"deploy_status=1&"
			"device_type=4&"
			"method=push_msg&"
			"message_type=1&"
			"messages=%s&"
			"msg_keys=%s&"
			"push_type=2&"
			"tag=%s&"
			"timestamp=%d&",
			//"user_id=1881857505&"
			BPUSH_P4PLIVE_API_KEY, md5, encode_message, msg_keys, BPUSH_P4PLIVE_SECRET_KEY, (int)curtime);
	sprintf(post_message, "http://channel.api.duapp.com/rest/2.0/channel/channel?%s", post_message_body);
    
    NSString * urlString = [NSString stringWithFormat:@"%s",post_message];
    
    NSLog(@"BPush:[%@]",urlString);
    
    [SVHTTPRequest POST: urlString
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                BOOL result = [[response valueForKey:@"state"] boolValue];
                
                if(result){
                    
                }else{
                    NSString *error_code = [NSString stringWithFormat:@"%@", [response valueForKey:@"error_code"]];
                    NSString *error_msg = [NSString stringWithFormat:@"%@", [response valueForKey:@"error_msg"]];
                    NSLog(@"Failed code:%@ msg:%@",error_code,error_msg);
                }
            }];
}
@end
