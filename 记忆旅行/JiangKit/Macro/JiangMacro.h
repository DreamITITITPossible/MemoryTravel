//
//  JiangMacro.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#ifndef JiangMacro_h
#define JiangMacro_h
#import <CocoaLumberjack.h>
/**
 *  DDLog参数
 */
#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelWarning;
#endif

/**
 *  AppStore
 */
#define APP_STORE_URL_7_UNDER @""

#define APP_STORE_URL_7_SUPPER @""

#define SCREEN_RECT         [UIScreen mainScreen].bounds
#define SCREEN_SIZE         [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH        SCREEN_SIZE.width
#define SCREEN_HEIGHT       SCREEN_SIZE.height
#define JYXColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


/**
 *  UMeng参数
 */
// appkey:控制台应用app key
static NSString *const kUMengAppKey = @"58beca78734be4634d0021d4";
// channelID:渠道
static NSString *const kUMengChannelId = @"App Store";
// 微博
static NSString *const kSinaAppKey = @"2364640485";
static NSString *const kSinaAppSecret = @"3c7d7a38a046f9589d9a2c378344195b";
static NSString *const kSinaRedirectURI = @"http://www.sina.com";
// QQ
static NSString *const kTencentAppID = @"1106019150";
static NSString *const kTencentAppKey = @"VsjZ3VrqIQ7G0E5I";
// 微信
static NSString *const kWeChatAppID = @"wxa7919b2462c0f980";
static NSString *const kWeChatAppSecret = @"e2c4a7b7a1f1dbb84fc087fe17bad8f3";



#endif /* JiangMacro_h */
