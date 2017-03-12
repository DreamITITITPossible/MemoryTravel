//
//  BaseNavViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"icon_nav_back" HighLightedImageName:@"icon_nav_back" Size:CGSizeMake(12, 21) targetBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
  
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    // Do any additional setup after loading the view.
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
