//
//  DCCommonTools.h
//  Pi
//
//  Created by Wei-Cheng Huang on 10/13/14.
//  Copyright (c) 2014 PChome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSString (PITools)
- (NSString *)md5DigestString;
- (NSString *)sha1DigestString;
- (NSString *)sha256DigestString;
- (NSData *)md5Digest;
- (NSData *)sha1Digest;
- (NSData *)sha256Digest;
@end

@interface NSData (PITools)
- (NSString *)string;
- (NSString *)hexString;
- (NSString *)md5DigestString;
- (NSString *)sha1DigestString;
- (NSString *)sha256DigestString;
- (NSData *)md5Digest;
- (NSData *)sha1Digest;
- (NSData *)sha256Digest;
@end
