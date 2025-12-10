//
//  DCFinder.h
//  DCTV
//
//  Created by Frank on 2016/3/14.
//  Copyright © 2016年 DCTV. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface DCFinder : NSObject

// Class Method
+ (DCFinder *)sharedFinder;

// 解密
- (NSString *)getInformationFromUserDefaultsWithKey:(NSString *)aKey;
- (NSDictionary *)getInformationDicFromUserDefaultsWithKey:(NSString *)aKey;





@end
