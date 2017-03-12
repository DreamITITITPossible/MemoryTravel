//
//  NSString+MD5.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
// 字符串 转换 32位 MD5字符串小写
- (NSString *)stringWith32BitMD5Lower;
// 字符串 转换 32位 MD5字符串大写
- (NSString *)stringWith32BitMD5Upper;
// 字符串 转换 16位 MD5字符串小写
- (NSString *)stringWith16BitMD5Lower;
// 字符串 转换 16位 MD5字符串大写
- (NSString *)stringWith16BitMD5Upper;

@end
