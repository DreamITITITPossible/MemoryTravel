//
//  AppStoreUtils.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreUtils : NSObject

/**
 *  跳转到App Store评分或者升级
 */
+ (void)gotoAppStore;

/*
 *  当前程序的版本号
 */
@property (nonatomic,copy,readonly) NSString *version;


@end

