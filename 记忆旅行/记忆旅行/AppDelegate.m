//
//  AppDelegate.m
//  记忆旅行
//
//  Created by mac on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarViewController.h"
#import "LoginViewController.h"
#import "PersonalHomepageViewController.h"
#import "FirstEnterController.h"
#import "JiangFlashLabel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 捕获异常信息

void uncaughtExceptionHandler(NSException *exception) {
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *syserror = [NSString stringWithFormat:@"异常名称：%@\n异常原因：%@\n异常堆栈信息：%@", name, reason, stackArray];
    DDLogInfo(@"CRASH: %@", syserror);
    
    NSString *dirName = @"exception";
    NSString *fileDir = [NSString stringWithFormat:@"%@/%@/", [FileManagerUtils getDocumentsPath], dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[fileDir stringByExpandingTildeInPath]];
    [fileManager createFileAtPath:[fileDir stringByAppendingString:[NSDate getSystemTimeString]] contents:[syserror dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
   

    
    
//    [WeiboSDK registerApp:kSinaAppKey];
//    //设置WeiboSDK的调试模式
//    [WeiboSDK enableDebugMode:YES];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMengAppKey];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

    
    
    // 避免屏幕内多个button被同时点击
    [[UIButton appearance] setExclusiveTouch:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
        BOOL isFirstLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] boolValue];
        if (!isFirstLogin) {
            //是第一次
            FirstEnterController *firstEnterVC = [[FirstEnterController alloc] init];
            firstEnterVC.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
          

            self.window.rootViewController = firstEnterVC;
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstLogin"];
        }else{
            //不是首次启动
            
            RootTabBarViewController *rootabBarVC = [[RootTabBarViewController alloc] init];
            
            self.window.rootViewController = rootabBarVC;
            
        }
    
    
    //是第一次
   
    
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIView *launchView = viewController.view;
    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UIImageView *imageView = launchView.subviews[0];
    NSLog(@"%f", launchView.x);
    NSLog(@"%f", launchView.y);

    [mainWindow addSubview:launchView];
    NSString *str = @"记忆旅行";
    CGFloat width = [str widthWithFont:[UIFont boldSystemFontOfSize:24] constrainedToHeight:25];
   
    JiangFlashLabel *flashLabel = [[JiangFlashLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - width / 2, imageView.y + imageView.height + 20, width, 25)];
//    flashLabel.textAlignment = NSTextAlignmentCenter;
    flashLabel.text = str;
    flashLabel.font = [UIFont boldSystemFontOfSize:24];
    [flashLabel startAnimating];
    [launchView addSubview:flashLabel];
    NSLog(@"%f", launchView.width);
    NSLog(@"%f", launchView.height);


    [UIView animateWithDuration:0.2f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.7f, 0.7f, 0.7f);
        flashLabel.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.7f, 0.7f, 0.7f);
       

        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
             launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.f, 1.f, 1.f);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                
                launchView.alpha = 0.0f;
                launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.f, 2.f, 2.f);
                
            } completion:^(BOOL finished) {
                [flashLabel stopAnimating];
                [launchView removeFromSuperview];
                [self networkReachability];
                
            }];
            
        }];
     
        
    }];
    
  
    
    
    [self DDLogsetup];
    [self initMobClick];
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
//    DDLogError(NSHomeDirectory());
    
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWeChatAppID appSecret:kWeChatAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kTencentAppID/*设置QQ平台的appID*/  appSecret:kTencentAppKey redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAppKey  appSecret:kSinaAppSecret redirectURL:kSinaRedirectURI];
  }


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//2.支持目前所有iOS系统

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
////    WeiboSDKResponseStatusCodeSuccess               = 0,//成功
////    WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
////    WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
////    WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
////    WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
////    WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
////    WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
////    WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
////    WeiboSDKResponseStatusCodeUnknown               = -100,
//
//    switch (response.statusCode) {
//        case -1:
//            [MBProgressHUD showTipMessageInWindow:@"取消"];
//
//            break;
//        case -2:
//            [MBProgressHUD showTipMessageInWindow:@"发送失败"];
//
//            break;
//        case -3:
//            [MBProgressHUD showTipMessageInWindow:@"授权失败"];
//            break;
//        default:
//            break;
//    }
////    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
////    {
////        NSString *title = NSLocalizedString(@"发送结果", nil);
////        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                              otherButtonTitles:nil];
////        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
////        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
////        if (accessToken)
////        {
//////            self.wbtoken = accessToken;
////        }
////        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
////        if (userID) {
//////            self.wbCurrentUserID = userID;
////        }
////        [alert show];
////    }
////    else if ([response isKindOfClass:WBAuthorizeResponse.class])
////    {
////        NSString *title = NSLocalizedString(@"认证结果", nil);
////        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                              otherButtonTitles:nil];
////        
//////        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//////        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//////        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
////        [alert show];
////    }
////    else if ([response isKindOfClass:WBPaymentResponse.class])
////    {
////        NSString *title = NSLocalizedString(@"支付结果", nil);
////        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                              otherButtonTitles:nil];
////        [alert show];
////    }
////    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
////    {
////        NSString *title = NSLocalizedString(@"邀请结果", nil);
////        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                              otherButtonTitles:nil];
////        [alert show];
////    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
////    {
////        NSString *title = NSLocalizedString(@"发送结果", nil);
////        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                        message:message
////                                                       delegate:nil
////                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                              otherButtonTitles:nil];
////        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
////        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
////        if (accessToken)
////        {
//////            self.wbtoken = accessToken;
////        }
////        NSString* userID = [shareMessageToContactResponse.authResponse userID];
////        if (userID) {
//////            self.wbCurrentUserID = userID;
////        }
////        [alert show];
////    }
//}
//#pragma mark 9.0之前
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//
//
//// 9.0 后才生效
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//



#pragma mark - NetworkReachability

- (void)networkReachability {
    AFNetworkReachabilityManager *mar = [AFNetworkReachabilityManager sharedManager];
    [mar setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                [MBProgressHUD showTipMessageInWindow:@"未使识别的网络"];
                NSLog(@"未使识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                [MBProgressHUD showTipMessageInWindow:@"未连接网络"];
                NSLog(@"不可达的（未连接的）");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                [MBProgressHUD showTipMessageInWindow:@"2G,3G,4G 网络"];
                NSLog(@"2G，3G 4G 网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [MBProgressHUD showTipMessageInWindow:@"WIFi"];
                NSLog(@"WIFi");
                break;
            }
        }
    }];
    
    [mar startMonitoring];
}

#pragma makr UMeng

- (void)initMobClick {
    UMConfigInstance.appKey = kUMengAppKey;
    UMConfigInstance.channelId = kUMengChannelId;
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark setup

- (void)DDLogsetup {
    
    //    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //开启使用 XcodeColors
    setenv("XcodeColors", "YES", 0);
    //检测
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled!
        NSLog(@"XcodeColors is installed and enabled");
    }
    
    //开启DDLog 颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor brownColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
