//
//  RootTabBarViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "CCNavigationController.h"
#import "CCLayerAnimation.h"
#import "HomeViewController.h"
#import "DestinationViewController.h"
#import "TravelNotesViewController.h"
#import "MineViewController.h"
@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    //    homeVC.title = @"主页";
    CCNavigationController *homeNav = [[CCNavigationController alloc] initWithRootViewController:homeVC];
    
//    CCLayerAnimation *homelayerAnimation = [[CCLayerAnimation alloc] initWithType:CCLayerAnimationCover];
    
//    homeNav.animationController = homelayerAnimation;
//    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UIImage *homeImage = [UIImage imageNamed:@"icon_tabbar_home"];
    homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *homeSelectedImage = [UIImage imageNamed:@"icon_tabbar_home_selected"];
    homeSelectedImage = [homeSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:homeImage selectedImage:homeSelectedImage];
    
    
    DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
    CCNavigationController *destinationNav = [[CCNavigationController alloc] initWithRootViewController:destinationVC];

//    UINavigationController *destinationNav = [[UINavigationController alloc] initWithRootViewController:destinationVC];
    
    
    UIImage *destinationImage = [UIImage imageNamed:@"icon_tabbar_aim"];
    destinationImage = [destinationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *destinationSelectedImage = [UIImage imageNamed:@"icon_tabbar_aim_selected"];
    destinationSelectedImage = [destinationSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    destinationNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"目的地" image:destinationImage selectedImage:destinationSelectedImage];
    
    TravelNotesViewController *travelNotesVC = [[TravelNotesViewController alloc] init];
       CCNavigationController *travelNotesNav = [[CCNavigationController alloc] initWithRootViewController:travelNotesVC];
//    UINavigationController *travelNotesNav = [[UINavigationController alloc] initWithRootViewController:travelNotesVC];
    UIImage *travelNotesImage = [UIImage imageNamed:@"icon_tabbar_travelNotes"];
    travelNotesImage = [travelNotesImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *travelNotesSelectedImage = [UIImage imageNamed:@"icon_tabbar_travelNotes_selected"];
    travelNotesSelectedImage = [travelNotesSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    travelNotesNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"游记" image:travelNotesImage selectedImage:travelNotesSelectedImage];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    CCNavigationController *mineNaV = [[CCNavigationController alloc] initWithRootViewController:mineVC];

//    UINavigationController *mineNaV = [[UINavigationController alloc] initWithRootViewController:mineVC];
    UIImage *mineImage = [UIImage imageNamed:@"icon_tabbar_mine"];
    mineImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mineSelectedImage = [UIImage imageNamed:@"icon_tabbar_mine_selected"];
    mineSelectedImage = [mineSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    mineNaV.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:mineImage selectedImage:mineSelectedImage];
    
    
    
    
    // 设置被管理的视图控制器 (或者导航视图控制器)
    self.viewControllers = @[homeNav, destinationNav, travelNotesNav, mineNaV];
    // tabBar选中颜色
    self.tabBar.tintColor = JYXColor(64, 225, 208, 1);
    // tabBar背景颜色
    self.tabBar.barTintColor = JYXColor(245, 245, 245, 1);
    //    rootTabBarController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    //    rootTabBarController.tabBarItem.titlePositionAdjustment = UIOffsetMake(10, 10);
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    // 是否半透明
    self.tabBar.translucent = NO;
    
    //    self.window.rootViewController = rootTabBarController;
    

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
