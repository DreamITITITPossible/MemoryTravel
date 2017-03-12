//
//  NSString+MD5.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)
- (NSString *)stringWith32BitMD5 {
    // 1.将字符串转换成C语言字符串
    const char *cString = [self UTF8String];
    CC_LONG length = (CC_LONG)strlen(cString);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    // 2.将C的字符串转换 MD5
    CC_MD5(cString, length, bytes);
    // 3.将C的字符串转换成OC的字符串
    NSMutableString *finalMD5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [finalMD5String appendFormat:@"%02x", bytes[i]];
    }
    return finalMD5String;
}

- (NSString *)stringWith32BitMD5Lower {
    return [[self stringWith32BitMD5] lowercaseString];
}

- (NSString *)stringWith32BitMD5Upper {
    return [[self stringWith32BitMD5] uppercaseString];
}

- (NSString *)stringWith16BitMD5 {
    NSString *md5String32Bit = [self stringWith32BitMD5];
    NSString *md5String16Bit = [md5String32Bit substringToIndex:md5String32Bit.length - 8];
    md5String16Bit = [md5String16Bit substringFromIndex:8];
    return md5String16Bit;
}

- (NSString *)stringWith16BitMD5Lower {
    return [[self stringWith16BitMD5] lowercaseString];
}

- (NSString *)stringWith16BitMD5Upper {
    return [[self stringWith16BitMD5] uppercaseString];
}

@end
