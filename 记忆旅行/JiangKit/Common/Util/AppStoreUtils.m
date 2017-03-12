//
//  AppStoreUtils.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "AppStoreUtils.h"
#import "SystemUnit.h"

@implementation AppStoreUtils

/*
 *  跳转到App Store评分或者升级
 */
+ (void)gotoAppStore{
    NSString *url;
    if (SYSTEM_VERSION < 7) {
        url = APP_STORE_URL_7_UNDER;
    } else {
        url = APP_STORE_URL_7_SUPPER;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/*
 *  当前程序的版本号
 */
- (NSString *)version{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    return versionValueStringForSystemNow;
}

@end
