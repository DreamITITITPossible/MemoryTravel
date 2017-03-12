//
//  NSString+Categories.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Categories)

/**
 *  计算 MD5 值
 *
 *   传入需加密的字符串
 *
 *  @return 加密后的字符串
 */


- (NSString *)md5;
/**
 *  对 URL 进行编码
 *
 *  @return 编码后的 URL
 */
- (NSString *)urlEncode;


/**
 *  检测字符串是否为空（nil或者空字符串）
 *
 *  @param trim 是否忽略前后空白字符
 *
 *  @return 是否为空
 */

+(BOOL)isEmpty:(NSString *)str trim:(BOOL)trim;


@end
