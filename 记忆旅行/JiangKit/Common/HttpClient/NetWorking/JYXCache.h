//
//  JYXCache.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/28.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYXCache : NSObject

/**
 存储缓存
 
 @param data 网络数据
 @param key key
 */
+ (void)saveDataCache: (id)data forKey:(NSString *)key;


/**
 读取缓存
 
 @param key key
 */
+ (id)readCache:(NSString *)key ;

/**
 获取缓存总大小
 */
+ (unsigned long long)getAllCacheSize;

/**
 删除指定缓存
 
 @param key key
 */
+ (void)removeChache:(NSString *)key;

/**
 删除全部缓存
 */
+ (void)removeAllCache;

@end
