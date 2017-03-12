//
//  ResetPWDViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ResetPWDViewController.h"

@interface ResetPWDViewController ()

@end

@implementation ResetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"重置密码"];
    UILabel *cueLabel = [[UILabel alloc] init];
    cueLabel.backgroundColor = [UIColor clearColor];
    cueLabel.text = @"新密码将发送到您的手机";
    cueLabel.textColor = [UIColor lightGrayColor];
    cueLabel.font = kFONT_SIZE_15;
    [self.view addSubview:cueLabel];
    CGFloat cueWidth = [cueLabel.text widthWithFont:cueLabel.font constrainedToHeight:15];
    [cueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH / 2 - cueWidth / 2);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH / 2 - cueWidth / 2));
        make.height.equalTo(@15);
    }];
    // Do any additional setup after loading the view.
    UITextField *telTextField = [[UITextField alloc] init ];
    telTextField.backgroundColor = [UIColor clearColor];
    telTextField.borderStyle = UITextBorderStyleRoundedRect;
    telTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    telTextField.dk_tintColorPicker = DKColorPickerWithColors([UIColor lightGrayColor], [UIColor lightGrayColor]);
    telTextField.placeholder = @" 请输入注册手机号码";
    telTextField.keyboardType = UIKeyboardTypePhonePad;
    
    [self.view addSubview:telTextField];
    [telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cueLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@40);
    }];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送新密码" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:255.0 / 255 green:255.0 / 255 blue:255.0 / 255 alpha:1.0] forState:UIControlStateNormal];
    sendButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [sendButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([telTextField.text isPhoneNumber]) {
            NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
            // Body
            NSString *bodyStr = [NSString stringWithFormat:@"&cmd=restpwd&tel=%@", telTextField.text];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                
                NSDictionary *dic = result;
                
                NSNumber *flag = [dic objectForKey:@"flag"];
                NSString *msg = [dic objectForKey:@"result"];
                if ([flag isEqual:@1]) {
                    [self.delegate resetPasswordOfTEL:telTextField.text];
                     [MBProgressHUD showTipMessageInWindow:msg];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                     [MBProgressHUD showTipMessageInWindow:msg];
                }
                
            } failure:^(NSError *error) {
                
                
            }];

                  } else {
             [MBProgressHUD showTipMessageInWindow:@"请输入正确的手机号码"];
        }
        
    }];

    sendButton.layer.cornerRadius = 4;
    sendButton.clipsToBounds = YES;
    [self.view addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(telTextField.mas_height);
    }];
    
    UILabel *cueBottomLabel = [[UILabel alloc] init];
    cueBottomLabel.backgroundColor = [UIColor clearColor];
    cueBottomLabel.text = @"请保管好新密码或登录后修改密码";
    cueBottomLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    cueBottomLabel.font = kFONT_SIZE_12_BOLD;
    [self.view addSubview:cueBottomLabel];
    CGFloat cueBottomWidth = [cueBottomLabel.text widthWithFont:cueBottomLabel.font constrainedToHeight:15];
    [cueBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendButton.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH / 2 - cueBottomWidth / 2);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH / 2 - cueBottomWidth / 2));
        make.height.equalTo(@15);
    }];

    
    
    
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
