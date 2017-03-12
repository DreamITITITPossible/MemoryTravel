//
//  UserAgreementViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger num;
@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.num = 1;
      self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/a6a20342b163"]];
    [self.view addSubview:_webView];
    _webView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.num == 1) {
        
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _hud.label.text = @"加载中...";
        [_hud showAnimated:YES];
        _num++;
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.num == 2) {
        [_hud hideAnimated:YES];
        _num++;
    }

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    return YES;
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
