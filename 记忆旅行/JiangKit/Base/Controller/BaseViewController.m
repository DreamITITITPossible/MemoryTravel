//
//  BaseViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIImageView *lineView;
@end
@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.navigationController.navigationBar.translucent = NO;
    _lineView = [self findlineviw:self.navigationController.navigationBar];
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:kFONT_SIZE_18_BOLD,
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:kFONT_SIZE_18_BOLD,
           NSForegroundColorAttributeName:[UIColor blackColor]}];

    }


    // Do any additional setup after loading the view.
}
- (UIImageView*)findlineviw:(UIView*)view{
    
    if ([view isKindOfClass:[UIImageView class]]&&view.bounds.size.height<=1.0) {
        return (UIImageView*) view;
    }for (UIImageView *subview in view.subviews) {
        UIImageView *lineview = [self findlineviw:subview];
        if (lineview) {
            return lineview;
        }
    }
    return nil;
    
}
- (void)presentToLoginVC {
    
    
 
    CCSlideAnimation *slideAnimation = [[CCSlideAnimation alloc] init];
    slideAnimation.type = CCSlideAnimationFromTop;
    self.animationController = slideAnimation;

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *LoginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    loginVC.transitioningDelegate = self.transitioningDelegate; // this is important for the transition to work
    [self.navigationController presentViewController:LoginNav animated:YES completion:nil];
    

}
- (void)showAlertActionLogin {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"您未登录, 请先登陆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentToLoginVC];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:destructiveAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _lineView.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _lineView.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _lineView.hidden = YES;
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
