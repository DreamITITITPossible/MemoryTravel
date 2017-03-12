//
//  NSString+Regex.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Regex)


/**
 *  匹配邮箱
 */
- (BOOL)isEmail;

/**
 *  匹配手机号码
 */
- (BOOL)isPhoneNumber;

/**
 *  匹配中国移动手机号码
 */
- (BOOL)isCMPhoneNumber;

/**
 *  匹配中国联通手机号码
 */
- (BOOL)isCUPhoneNumber;

/**
 *  匹配中国电信手机号码
 */
- (BOOL)isCTPhoneNumber;

/**
 *  匹配国内电话号码
 */
- (BOOL)isCallNumber;

/**
 *  匹配QQ号码
 */
- (BOOL)isQQ;

/**
 *  匹配网址URL的正则表达式
 */
- (BOOL)isURL;

/**
 *  匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)
 */
- (BOOL)isLegalCount;

/**
 *  匹配中国邮政编码
 */
- (BOOL)isPostcode;

/**
 *  匹配身份证
 */
- (BOOL)isIDCardNumber;

/**
 *  匹配ip地址
 */
-(BOOL)isIpAddress;






@end
