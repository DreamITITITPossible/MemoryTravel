//
//  RegisterView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UITextField *telephoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *getVerifyCodeButton;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, assign) BOOL eyeIsClose;

@end
@implementation RegisterView
@synthesize telephoneText = _telephoneText;
@synthesize passwordText = _passwordText;
@synthesize verifyCodeText = _verifyCodeText;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.eyeIsClose = YES;
        self.telephoneTextField = [[UITextField alloc] init];
        _telephoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _telephoneTextField.layer.borderWidth = 0.5;
        _telephoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _telephoneTextField.layer.cornerRadius = 6;
        _telephoneTextField.placeholder = @"  请 输 入 验 证 码";
        _telephoneTextField.clipsToBounds = YES;
        _telephoneTextField.delegate = self;
        _telephoneTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        [self addSubview:_telephoneTextField];
        [_telephoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@40);
        }];
        _telephoneTextField.placeholder = @"  请 输 入 手 机 号";
        
        
        self.verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(180, 180, 10, 10)];
        _verifyCodeTextField.keyboardType = UIKeyboardTypePhonePad;
        _verifyCodeTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        _verifyCodeTextField.layer.borderWidth = 0.5;
        _verifyCodeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _verifyCodeTextField.layer.cornerRadius = 6;
        _verifyCodeTextField.placeholder = @"  请 输 入 验 证 码";
        _verifyCodeTextField.clipsToBounds = YES;
        _verifyCodeTextField.delegate = self;
        [self addSubview:_verifyCodeTextField];
        [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_telephoneTextField.mas_left).offset(0);
            make.top.equalTo(_telephoneTextField.mas_bottom).offset(10);
            make.height.equalTo(_telephoneTextField.mas_height);
            make.width.equalTo(@220);
        }];
        
        self.getVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerifyCodeButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
       
        _getVerifyCodeButton.layer.cornerRadius = 6;
        [self addSubview:_getVerifyCodeButton];
        [_getVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_verifyCodeTextField.mas_right).offset(10);
            make.top.equalTo(_telephoneTextField.mas_bottom).offset(10);
            make.height.equalTo(_telephoneTextField.mas_height);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        [_getVerifyCodeButton addTarget:self action:@selector(getVerifyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.passwordTextField = [[UITextField alloc] init];
        [self addSubview:_passwordTextField];
        _passwordTextField.layer.borderWidth = 0.5;
        _passwordTextField.delegate = self;
        _passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passwordTextField.placeholder = @"  请 输 入 6 - 12 位 密 码";
        _passwordTextField.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        _passwordTextField.layer.cornerRadius = 6;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clipsToBounds = YES;
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_verifyCodeTextField.mas_bottom).offset(10);
            make.left.equalTo(_telephoneTextField.mas_left).offset(0);
            make.right.equalTo(_telephoneTextField.mas_right).offset(0);
            make.height.equalTo(_telephoneTextField.mas_height).offset(0);
        }];
        
        UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [eyeButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
        
        [eyeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (self.eyeIsClose == YES) {
                [eyeButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
                _passwordTextField.secureTextEntry = NO;
            } else {
                [eyeButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
                _passwordTextField.secureTextEntry = YES;
            }
            self.eyeIsClose = !self.eyeIsClose;
            
        }];
        [self addSubview:eyeButton];
        [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordTextField.mas_top).offset(5);
            make.width.equalTo(@30);
            make.right.equalTo(_passwordTextField.mas_right).offset(-10);
            make.height.equalTo(@30);
            
        }];

        
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _bottomButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);

         [_bottomButton setTitle:@"下 一 步" forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_bottomButton];
        
        [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            
            make.right.equalTo(self.mas_right).offset(0);
            
            make.top.equalTo(self.mas_bottom).offset(-50);
            
            make.height.equalTo(@50);
            
            
        }];
        
    }
    return self;
}
- (void)startTime {
    __block int timeout= 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getVerifyCodeButton.userInteractionEnabled = YES;
                self.getVerifyCodeButton.backgroundColor = JYXColor(64, 224, 208, 1);
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.getVerifyCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.getVerifyCodeButton.userInteractionEnabled = NO;
                self.getVerifyCodeButton.backgroundColor = [UIColor grayColor];
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_passwordTextField resignFirstResponder];
    [_verifyCodeTextField resignFirstResponder];
    [_telephoneTextField resignFirstResponder];
    
}


- (void)nextStepAction:(UIButton *)button {
    [self.delegate nextStep:self.tag];
}

- (void)getVerifyCodeAction:(UIButton *)button {
    [self.delegate getVerifyCode:self.tag];
}

- (void)settelephoneText:(NSString *)telephoneText {
    if (_telephoneText != telephoneText) {
        _telephoneText = telephoneText;
        _telephoneTextField.text = _telephoneText;
    }
}
- (void)setVerifyCodeText:(NSString *)verifyCodeText {
    if (_verifyCodeText != verifyCodeText) {
        _verifyCodeText = verifyCodeText;
        _verifyCodeTextField.text = _verifyCodeText;
    }
}
- (void)setPasswordText:(NSString *)passwordText {
    if (_passwordText != passwordText) {
        _passwordText = passwordText;
        _passwordTextField.text = _passwordText;
    }
}

- (NSString *)telephoneText {
    _telephoneText = _telephoneTextField.text;
    return _telephoneText;
}
- (NSString *)verifyCodeText {
    _verifyCodeText = _verifyCodeTextField.text;
    return _verifyCodeText;
}
- (NSString *)passwordText {
    _passwordText = _passwordTextField.text;
    return _passwordText;
}


@end
