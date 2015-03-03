//
//  sha1.h
//  RSeePro
//
//  Created by longterm on 12-10-15.
//
//

#include "sys/types.h"
#include "stdio.h"
#include <stdlib.h>
#include <string.h>

#ifndef RSeePro_sha1_h
#define RSeePro_sha1_h

struct sha1_ctx
{
    unsigned int A;
    unsigned int B;
    unsigned int C;
    unsigned int D;
    unsigned int E;
    
    unsigned int total[2];
    unsigned int buflen;
    unsigned int buffer[32];
};

//typedef unsigned int size_t;
typedef unsigned int uint32_t;

#ifdef WORDS_BIGENDIAN
# define SWAP(n) (n)
#else
# define SWAP(n) \
(((n) << 24) | (((n) & 0xff00) << 8) | (((n) >> 8) & 0xff00) | ((n) >> 24))
#endif

#define BLOCKSIZE 4096
#if BLOCKSIZE % 64 != 0
# error "invalid BLOCKSIZE"
#endif

/* Initialize structure containing state of computation. */
void sha1_init_ctx (struct sha1_ctx *ctx);

/* Starting with the result of former calls of this function (or the
 initialization function update the context for the next LEN bytes
 starting at BUFFER.
 It is necessary that LEN is a multiple of 64!!! */
void sha1_process_block (const void *buffer, size_t len,
                         struct sha1_ctx *ctx);

/* Starting with the result of former calls of this function (or the
 initialization function update the context for the next LEN bytes
 starting at BUFFER.
 It is NOT required that LEN is a multiple of 64.  */
void sha1_process_bytes (const void *buffer, size_t len,
                         struct sha1_ctx *ctx);

/* Process the remaining bytes in the buffer and put result from CTX
 in first 20 bytes following RESBUF.  The result is always in little
 endian byte order, so that a byte-wise output yields to the wanted
 ASCII representation of the message digest.
 
 IMPORTANT: On some systems it is required that RESBUF be correctly
 aligned for a 32 bits value.  */
void *sha1_finish_ctx (struct sha1_ctx *ctx, void *resbuf);


/* Put result from CTX in first 20 bytes following RESBUF.  The result is
 always in little endian byte order, so that a byte-wise output yields
 to the wanted ASCII representation of the message digest.
 
 IMPORTANT: On some systems it is required that RESBUF is correctly
 aligned for a 32 bits value.  */
void *sha1_read_ctx (const struct sha1_ctx *ctx, void *resbuf);


/* Compute SHA1 message digest for bytes read from STREAM.  The
 resulting message digest number will be written into the 20 bytes
 beginning at RESBLOCK.  */
//int sha1_stream (FILE *stream, void *resblock);

int sha1_stream (FILE *stream, void *resblock);

/* Compute SHA1 message digest for LEN bytes beginning at BUFFER.  The
 result is always in little endian byte order, so that a byte-wise
 output yields to the wanted ASCII representation of the message
 digest.  */
void *sha1_buffer (const char *buffer, size_t len, void *resblock);

void *memxor (void * dest, const void * src, size_t n);

int
hmac_sha1 (const void *key, size_t keylen,
           const void *in, size_t inlen, void *resbuf);

char* trans_sha1_string(const char* sha1, const int size, char* result);

#endif
