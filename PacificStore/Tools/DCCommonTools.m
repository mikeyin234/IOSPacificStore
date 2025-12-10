//
//  DCCommonTools.m
//  Pi
//
//  Created by Wei-Cheng Huang on 10/13/14.
//  Copyright (c) 2014 PChome Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "DCCommonTools.h"
#import "DCFinder.h"
#import "DCUpdater.h"

typedef enum {
    PIDigestTypeMD5,
    PIDigestTypeSHA1,
    PIDigestTypeSHA256
} PIDigestType;

static NSArray * kPIBase36MappingArray = nil;

@implementation NSString (PITools)

- (NSString *)md5DigestString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5DigestString];
}

- (NSString *)sha1DigestString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1DigestString];
}

- (NSString *)sha256DigestString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256DigestString];
}

- (NSData *)md5Digest {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Digest];
}

- (NSData *)sha1Digest {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Digest];
}

- (NSData *)sha256Digest {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256Digest];
}

@end

@implementation NSData (PITools)

- (NSString *)string {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)hexString {
    NSMutableString *str = [NSMutableString stringWithCapacity:64];
    int length = (int)[self length];
    char *bytes = malloc(sizeof(char) * length);
    [self getBytes:bytes length:length];
    for (int i = 0; i < length; i++) {
        [str appendFormat:@"%02.2hhx", bytes[i]];
    }
    free(bytes);
    return str;
}

- (NSString *)md5DigestString {
    return [[self md5Digest] hexString];
}

- (NSString *)sha1DigestString {
    return [[self sha1Digest] hexString];
}

- (NSString *)sha256DigestString {
    return [[self sha256Digest] hexString];
}

- (NSData *)digest:(PIDigestType)type {
    NSUInteger digestLength;
    unsigned char * (*digestFunction)(const void *, CC_LONG, unsigned char *) = NULL;
    switch (type) {
        case PIDigestTypeMD5:
            digestLength = CC_MD5_DIGEST_LENGTH;
            digestFunction = CC_MD5;
            break;
        case PIDigestTypeSHA1:
            digestLength = CC_SHA1_DIGEST_LENGTH;
            digestFunction = CC_SHA1;
            break;
        case PIDigestTypeSHA256:
            digestLength = CC_SHA256_DIGEST_LENGTH;
            digestFunction = CC_SHA256;
            break;
    }
    unsigned char digest[digestLength];
    digestFunction((const char *)[self bytes], (uint32_t)[self length], digest);
    return [NSData dataWithBytes:digest length:digestLength];
}

- (NSData *)md5Digest {
    return [self digest:PIDigestTypeMD5];
}

- (NSData *)sha1Digest {
    return [self digest:PIDigestTypeSHA1];
}

- (NSData *)sha256Digest {
    return [self digest:PIDigestTypeSHA256];
}

@end
