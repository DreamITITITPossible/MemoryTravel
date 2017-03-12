//
//  NSDictionary+Check.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Categories)

/**
 *  非空校验（nil或者元素个数为0）
 *
 *  @return 是否为空
 */
+(BOOL)isEmpty:(NSDictionary *)dict;

@end
