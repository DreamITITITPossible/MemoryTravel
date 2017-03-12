//
//  RegisterViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "InformationViewController.h"
#import "UserAgreementViewController.h"
@interface RegisterViewController ()
<
RegisterViewDelegate
>
@property (nonatomic, strong) RegisterView *registerView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
   
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createView];
}
- (void)createView {
    
    self.registerView = [[RegisterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _registerView.tag = 1001;
    _registerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.registerView.delegate = self;
   
    
    [self.view addSubview:_registerView];
    
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"阅读并同意";
    CGFloat width = [label.text widthWithFont:label.font constrainedToHeight:30];
    label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(175);
        
        make.left.equalTo(self.view.mas_left).offset(15);
        
        make.height.equalTo(@30);
        
        make.width.mas_equalTo(width);
        
        
    }];
    
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [agreementButton setTitle:@"<<记忆用户协议>>" forState:UIControlStateNormal];
    agreementButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [agreementButton dk_setTitleColorPicker:DKColorPickerWithKey(BTNGREENBG) forState:UIControlStateNormal];
    
    [agreementButton addTarget:self action:@selector(agreementAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:agreementButton];
    
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label.mas_top).offset(0);
        
        make.left.equalTo(label.mas_right).offset(0);
        
        make.height.equalTo(@30);
        
        make.width.equalTo(@150);
        
        
    }];
    
    
}




- (void)agreementAction:(UIButton *)agreementbutton {
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
     userAgreementVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"记忆旅行"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}
- (void)nextStep:(NSInteger)tag {
        if ([_registerView.telephoneText isPhoneNumber]) {
            if (_registerView.verifyCodeText.length == 4) {
                if (_registerView.passwordText.length >= 6 && _registerView.passwordText.length <= 12) {
                    
            NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
            // Body
            NSString *bodyStr = [NSString stringWithFormat:@"&sec=%@&PWD=%@&TEL=%@&cmd=rgchk", _registerView.verifyCodeText, [_registerView.passwordText md5],_registerView.telephoneText];
                HttpClient *httpClient = [[HttpClient alloc] init];
               [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
                NSDictionary *dic = result;
                
                NSNumber *flag = [dic objectForKey:@"flag"];
                NSString *msg = [dic objectForKey:@"result"];
                if ([flag isEqual:@0]) {
                    [MBProgressHUD showTipMessageInWindow:msg];
                    
                } else {
            
            InformationViewController *infoVC = [[InformationViewController alloc] init];
                    infoVC.verifyCode = _registerView.verifyCodeText;
                    infoVC.PWD = [_registerView.passwordText md5];
                    infoVC.TELE = _registerView.telephoneText;
             infoVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"完善信息"];
            self.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:infoVC animated:YES];

                }
                
            } failure:^(NSError *error) {
                //            NSLog(@"%@", error);
            }];
                } else if (_registerView.passwordText.length == 0){
                    
                    [MBProgressHUD showTipMessageInWindow:@"密码不能为空"];
                } else {
                     [MBProgressHUD showTipMessageInWindow:@"请注意密码长度"];
                }
            } else if (_registerView.verifyCodeText.length == 0){
                
                 [MBProgressHUD showTipMessageInWindow:@"验证码不能为空"];
            } else {
                 [MBProgressHUD showTipMessageInWindow:@"验证码输入错误!"];
            }
        } else if (_registerView.telephoneText.length == 0){
            
             [MBProgressHUD showTipMessageInWindow:@"手机号不能为空"];
        } else {
             [MBProgressHUD showTipMessageInWindow:@"手机号码错误"];

        }
    
        
    
}






#pragma mark - 获取验证码
- (void)getVerifyCode:(NSInteger)tag{
    if (tag == 1001) {
        if ([_registerView.telephoneText isPhoneNumber]) {
            NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
        // Body
            NSString *bodyStr = [NSString stringWithFormat:@"&cmd=verify&tel=%@", _registerView.telephoneText];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                NSDictionary *dic = result;
                
                NSNumber *flag = [dic objectForKey:@"flag"];
                NSString *msg = [dic objectForKey:@"result"];
                     [MBProgressHUD showTipMessageInWindow:msg];
                if ([flag isEqual:@1]) {
                    [_registerView startTime];
                }
                
                
            } failure:^(NSError *error) {
                
            }];
            
        } else {
             [MBProgressHUD showTipMessageInWindow:@"手机号填写错误!"];
            
        }
    }
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
