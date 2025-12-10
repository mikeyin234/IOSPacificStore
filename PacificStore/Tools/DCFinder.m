//
//  DCFinder.m
//  DCTV
//
//  Created by Frank on 2016/3/14.
//  Copyright © 2016年 DCTV. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DCFinder.h"
#import "DCCommonTools.h"
#import "AESCrypt.h"


static DCFinder *instance_ = nil;

@implementation DCFinder

+ (DCFinder *)sharedFinder {
    @synchronized (self) {
        if (nil == instance_) {
            instance_ = [[DCFinder alloc] init];
        }
    }
    return instance_;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 解密

- (NSString *)getInformationFromUserDefaultsWithKey:(NSString *)aKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    password = [password sha256DigestString];
    NSString *key = [AESCrypt encrypt:aKey password:password];
    NSString *value = [userDefaults objectForKey:key];
    return [AESCrypt decrypt:value password:password];
}


- (NSDictionary *)getInformationDicFromUserDefaultsWithKey:(NSString *)aKey {
    NSString *decryptString = [self getInformationFromUserDefaultsWithKey:aKey];
    NSDictionary *valueDic = [NSDictionary dictionary];
    
    if (nil != decryptString && ![@"" isEqualToString:decryptString]) {
        NSError *jsonReadError = nil;
        id responseObj = [NSJSONSerialization JSONObjectWithData:
                          [decryptString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonReadError];
        
        if (nil == jsonReadError) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                valueDic = responseObj;
            }
        }
    }
    
    return valueDic;
}

@end
