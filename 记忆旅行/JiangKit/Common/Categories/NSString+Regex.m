//
//  NSString+Regex.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString(Regex)

/**
 *  匹配邮箱
 */
- (BOOL)isEmail {
    NSString * regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配手机号码
 */
- (BOOL)isPhoneNumber {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * regex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配中国移动手机号码
 */
- (BOOL)isCMPhoneNumber {
    NSString * regex = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配中国联通手机号码
 */
- (BOOL)isCUPhoneNumber {
    NSString * regex = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配中国电信手机号码
 */
- (BOOL)isCTPhoneNumber {
    NSString * regex = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配国内电话号码
 */
- (BOOL)isCallNumber {
    NSString * regex = @"d{3}-d{8}|d{4}-d{7}";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配QQ号码
 */
- (BOOL)isQQ {
    NSString * regex = @"[1-9][0-9]{4,}";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配网址URL
 */
- (BOOL)isURL {
    NSString * regex = @"[a-zA-z]+://[^s]*";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)
 */
- (BOOL)isLegalCount {
    NSString * regex = @"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配中国邮政编码
 */
- (BOOL)isPostcode {
    NSString * regex = @"[1-9]d{5}(?!d)";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配身份证
 */
- (BOOL)isIDCardNumber {
    NSString * regex = @"d{15}|d{18}";
    return [self checkStringWithRegex:regex checkString:self];
}

/**
 *  匹配ip地址
 */
-(BOOL)isIpAddress {
    NSString * regex = @"d+.d+.d+.d+";
    return [self checkStringWithRegex:regex checkString:self];
}

#pragma mark - private

- (BOOL)checkStringWithRegex:(NSString *)regex checkString:(NSString *)checkString {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:checkString];
}


@end
