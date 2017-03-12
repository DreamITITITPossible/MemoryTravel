//
//  LoginViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "LoginViewController.h"
#import "Login_Custom_View.h"
#import "RegisterViewController.h"
#import "ResetPWDViewController.h"
#import "InformationViewController.h"
#import "PersonalInfo.h"
#import "User.h"
#import "UserInfo.h"
@interface LoginViewController ()
<
ResetPWDViewControllerDelegate
>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong)Login_Custom_View *userView;
@property (nonatomic, strong)Login_Custom_View *passwordView;
@property (nonatomic, assign) BOOL eyeIsClose;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      
    UIBarButtonItem *cancelItem = [UIBarButtonItem getBarButtonItemWithImageName:@"icon_nav_cancel" HighLightedImageName:@"icon_nav_cancel" Size:CGSizeMake(21, 21) targetBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    self.view.backgroundColor = JYXColor(245, 245, 245, 1);
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"登陆"];;
    self.eyeIsClose = YES;
    [self createView];
    
}
- (void) createView {

//    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_back"]];
//    [self.view addSubview:_backImageView];
//    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(self.view.mas_width);
//        
//    }];
    
    
    self.userView = [[Login_Custom_View alloc] init];
    
    _userView.placeholder = @" 请 输 入 手 机 号";
    _userView.textField.keyboardType = UIKeyboardTypePhonePad;
    _userView.image = [UIImage imageNamed:@"login_telephone"];
    [self.view addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.equalTo(@50);
    }];
    
    self.passwordView = [[Login_Custom_View alloc] init ];
    _passwordView.placeholder = @" 请 输 入 密 码";
    _passwordView.image = [UIImage imageNamed:@"login_password"];
    
    _passwordView.textField.secureTextEntry = YES;
    [self.view addSubview:_passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userView.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.equalTo(_userView.mas_height);
    }];
    UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    
    [eyeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (self.eyeIsClose == YES) {
            [eyeButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
            _passwordView.textField.secureTextEntry = NO;
        } else {
            [eyeButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            _passwordView.textField.secureTextEntry = YES;
        }
        self.eyeIsClose = !self.eyeIsClose;
        
    }];
    [self.view addSubview:eyeButton];
    [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_top).offset(10);
        make.width.equalTo(@30);
        make.right.equalTo(_passwordView.mas_right).offset(-10);
        make.height.equalTo(@30);
        
    }];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:JYXColor(255, 255, 255, 1) forState:UIControlStateNormal];
    loginButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 25;
    loginButton.clipsToBounds = YES;
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_bottom).offset(80);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.equalTo(_passwordView.mas_height);
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerTravel) forControlEvents:UIControlEventTouchUpInside];
   
       [registerButton dk_setTitleColorPicker:DKColorPickerWithKey(BTNGREENBG) forState:UIControlStateNormal];
    
    
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.left.equalTo(loginButton.mas_left);
        make.right.equalTo(loginButton.mas_right);
        make.height.equalTo(loginButton.mas_height);
    }];
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [forgetButton setImage:[UIImage imageNamed:@"list_arrow_right"] forState:UIControlStateNormal];
//    CGSize forgetImageSize = forgetButton.imageView.frame.size;
//    CGSize forgetTitleSize = forgetButton.titleLabel.frame.size;
//    
//    forgetButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, forgetImageSize.width, 0.0, forgetImageSize.width * 2);
//    forgetButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, forgetTitleSize.width, 0.0, -forgetTitleSize.width * 17);
    
    
    
    
    
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [forgetButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordView.mas_bottom).offset(20);
        make.right.equalTo(_passwordView.mas_right);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [wechatButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    [wechatButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //    [forgetButton setImage:[UIImage imageNamed:@"list_arrow_right"] forState:UIControlStateNormal];
    //    CGSize forgetImageSize = forgetButton.imageView.frame.size;
    //    CGSize forgetTitleSize = forgetButton.titleLabel.frame.size;
    //
    //    forgetButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, forgetImageSize.width, 0.0, forgetImageSize.width * 2);
    //    forgetButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, forgetTitleSize.width, 0.0, -forgetTitleSize.width * 17);
    
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"icon_qq_third"] forState:UIControlStateNormal];
    
    
    
    wechatButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [wechatButton addTarget:self action:@selector(getAuthWithUserInfoFromQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatButton];
    
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerButton.mas_bottom).offset(40);
        make.right.equalTo(registerButton.mas_centerX).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    wechatButton.layer.cornerRadius = 30;
    wechatButton.clipsToBounds = YES;
    
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [wechatButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    //    [wechatButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //    [forgetButton setImage:[UIImage imageNamed:@"list_arrow_right"] forState:UIControlStateNormal];
    //    CGSize forgetImageSize = forgetButton.imageView.frame.size;
    //    CGSize forgetTitleSize = forgetButton.titleLabel.frame.size;
    //
    //    forgetButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, forgetImageSize.width, 0.0, forgetImageSize.width * 2);
    //    forgetButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, forgetTitleSize.width, 0.0, -forgetTitleSize.width * 17);
    
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"icon_weibo_third"] forState:UIControlStateNormal];
    
    
    
    [sinaButton addTarget:self action:@selector(getAuthWithUserInfoFromSina) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaButton];
    
    [sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerButton.mas_bottom).offset(40);
        make.left.equalTo(registerButton.mas_centerX).offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    sinaButton.layer.cornerRadius = 30;
    sinaButton.clipsToBounds = YES;

    
    
    
}
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
//        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
//        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}
- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            [self loginWithTokenID:resp.uid BandType:@"weibo" Name:resp.name IconURL:resp.iconurl];
        
        }

    }];
}
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
          
           
            
            
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            [self loginWithTokenID:resp.openid BandType:@"qq" Name:resp.name IconURL:resp.iconurl];

        }
    }];
}
- (void)loginWithTokenID:(NSString *)tokenID BandType:(NSString *)bandType Name:(NSString *)name IconURL:(NSString *)iconURL {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/tour?&tokenID=%@&bandtype=weibo&Sex=&cmd=thdrgall&photo=&Nickname=&Age=", tokenID];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient POST:urlStr body:nil bodyStyle:JYX_BodyJSON headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            if ([[result objectForKey:@"result"] isEqualToString:@"尚未注册"]) {
                InformationViewController *infoVC = [[InformationViewController alloc] init];
                infoVC.tokenID = tokenID;
                infoVC.bandType = bandType;
                infoVC.name = name;
                infoVC.headImgURL = iconURL;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];

            } else if ([[result objectForKey:@"result"] isEqualToString:@"登陆成功,谢谢"]) {
                User *user = [[User alloc] init];
                user.IMID = [result objectForKey:@"IMID"];
                user.SERISE = [result objectForKey:@"SERISE"];
                user.JSESSIONID = [result objectForKey:@"JSESSIONID"];

                user.isLogin = YES;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:data forKey:@"userData"];
                [userDefaults synchronize];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/ssh2/tour?&cmd=queryPersonalInfor&tel=%@", baseURL, [result objectForKey:@"tel1"]];
                [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:NO isShowHub:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                        PersonalInfo *personalInfo = [PersonalInfo mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
                        UserInfo *userinfo = [[UserInfo alloc] init];
                    
                        userinfo.Age = [result objectForKey:@"Age"];
                        userinfo.Age1 = [result objectForKey:@"Age1"];
                        userinfo.Address = [result objectForKey:@"Address"];
                        userinfo.kidneyname = [result objectForKey:@"Kidneyname"];
                        userinfo.Nickname = [result objectForKey:@"NickName"];
                        userinfo.Photo = [result objectForKey:@"Photo"];
                        userinfo.Sex = [result objectForKey:@"Sex"];
                        if ([[result objectForKey:@"tel"] isEqualToString:@""]) {
                            userinfo.TEL = [result objectForKey:@"tel1"];
                            
                        } else {
                            userinfo.TEL = [result objectForKey:@"tel"];
                        }
                        userinfo.QQ = personalInfo.QQ;
                        userinfo.Weibo = personalInfo.Weibo;
                        userinfo.Wechat = personalInfo.Wechat;
                        userinfo.Email = personalInfo.EMail;
                        userinfo.backpic = personalInfo.backpic;
                        userinfo.TourID = personalInfo.TouristID;
                        
                        UIImage *image = [UIImage getImageFromURL:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", userinfo.Photo]];
                        userinfo.headImage = image;
                        NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
                        NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
                        [userinfoDefaults setObject:userInfoData forKey:@"userInfoData"];
                        [userinfoDefaults synchronize];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                } readCachesIfFailed:^(id responseObject) {
                    
                } failed:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD showErrorMessage:@"error"];
                }];
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"error"];
        
    }];
}
//- (void)sinaLogin {
//    
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kSinaRedirectURI;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    [WeiboSDK sendRequest:request];
//  
//    InformationViewController *info = [[InformationViewController alloc] init];
//    [self.navigationController pushViewController:info animated:YES];
////    [self dismissViewControllerAnimated:YES completion:nil];
//
//}

- (void)login {
    if ([_userView.text isPhoneNumber]) {
        if (_passwordView.text.length != 0) {
            
        
        NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
        // Body
        NSString *bodyStr = [NSString stringWithFormat:@"&cmd=login&TEL=%@&PWD=%@", _userView.text, [_passwordView.text md5]];
        HttpClient *httpClient = [[HttpClient alloc] init];
        [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                NSDictionary *dic = result;
                
                NSNumber *flag = [dic objectForKey:@"flag"];
                NSString *msg = [dic objectForKey:@"result"];
                if ([flag isEqual:@1]) {
                    User *user = [User mj_objectWithKeyValues:dic];
                    
                    user.isLogin = YES;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:data forKey:@"userData"];
                    [userDefaults synchronize];

                    NSString *userInfoStr = [baseURL stringByAppendingString:@"/ssh2/tour?&cmd=getTour"];
                    NSDictionary *headDic =  @{@"Cookie" :[NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
                [httpClient GET:userInfoStr body:nil headerFile:headDic response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSNumber *flag2 = [result objectForKey:@"flag"];
                    NSArray *array2 = [result objectForKey:@"result"];
                    NSDictionary *dic2 = array2[0];
                    if ([flag2 isEqual:@1]) {
                        
                        UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:dic2];
                        UIImage *image = [UIImage getImageFromURL:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", userinfo.Photo]];
                        userinfo.headImage = image;
                        NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
                        NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
                        [userinfoDefaults setObject:userInfoData forKey:@"userInfoData"];
                        [userinfoDefaults synchronize];
                        [self dismissViewControllerAnimated:YES completion:nil];

                    }

                    
                } failure:^(NSError *error) {
                    
                    
                }];
                    
                    
                    
                    
                } else {
                     [MBProgressHUD showTipMessageInWindow:msg];
                }
                    } failure:^(NSError *error) {
        }];
        } else {
            [MBProgressHUD showTipMessageInWindow:@"密码不能为空!"];
        }
    } else {
         [MBProgressHUD showTipMessageInWindow:@"手机号码错误"];
    }
}


- (void)registerTravel {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.navigationController.navigationBarHidden = NO;
    registerVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"注册"];;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (void)forgetPassword {
    ResetPWDViewController *resetPWDVC = [[ResetPWDViewController alloc] init];
    resetPWDVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"找回密码"];;
    resetPWDVC.delegate = self;
    resetPWDVC.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resetPWDVC animated:YES];
    
}
#pragma mark - 重置密码协议实现
- (void)resetPasswordOfTEL:(NSString *)tel {
    _userView.text = tel;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userView.textField resignFirstResponder];
    [_passwordView.textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
