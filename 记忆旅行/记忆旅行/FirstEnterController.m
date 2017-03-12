//
//  FirstEnterController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/12.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "FirstEnterController.h"
#import "RootTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <FBShimmering.h>
#import <FBShimmeringView.h>
@interface FirstEnterController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic,strong) FBShimmeringView *shimmeringView2;
@property (nonatomic,strong) UILabel *shimmerLabel2;

@property (nonatomic,strong) UIButton *enterButton;
@end

@implementation FirstEnterController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc-->%s",object_getClassName(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    self.moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    [self.view addSubview:self.moviePlayer.view];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinsihed) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClip:)];
    [backView addGestureRecognizer:tap];
    [self.moviePlayer.view addSubview:backView];

    [self configShimmerLabel];
    //监听播放完成
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer play];
}


- (void)configShimmerLabel
{
    self.shimmeringView2 = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 50, SCREEN_WIDTH, 100)];
    self.shimmeringView2.shimmering = YES;
    self.shimmeringView2.shimmeringSpeed = 100;
    self.shimmeringView2.shimmeringOpacity = 0;
    self.shimmeringView2.shimmeringBeginFadeDuration = 0.3;
    self.shimmeringView2.shimmeringEndFadeDuration = 1;
    self.shimmeringView2.shimmeringAnimationOpacity = 0.6;
    [self.moviePlayer.view addSubview:self.shimmeringView2];
    
    self.shimmerLabel2 = [[UILabel alloc] initWithFrame:self.shimmeringView2.bounds];
    self.shimmerLabel2.text = @"记忆旅行";
    self.shimmerLabel2.textColor = [UIColor whiteColor];
    self.shimmerLabel2.textAlignment = NSTextAlignmentCenter;
    self.shimmerLabel2.font = [UIFont boldSystemFontOfSize:40];
    self.shimmerLabel2.backgroundColor = [UIColor clearColor];
    self.shimmeringView2.contentView = self.shimmerLabel2;
    
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterButton.layer.cornerRadius = 5.0f;
    self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.enterButton.layer.borderWidth = 2.0f;
    [self.enterButton setTitle:@"进入App" forState:UIControlStateNormal];
    [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.enterButton.backgroundColor = [UIColor clearColor];
    [self.enterButton addTarget:self action:@selector(clickEnter:) forControlEvents:UIControlEventTouchUpInside];
    [self.moviePlayer.view addSubview:self.enterButton];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.moviePlayer.view);
        make.top.equalTo(self.moviePlayer.view.mas_bottom).offset(-100);
        make.height.mas_equalTo(@(50));
        make.width.mas_equalTo(@(0));
    }];
    for (UIView *view in self.moviePlayer.view.subviews) {
        NSLog(@"%@", [view class]);
    }
    
}

- (void)clickEnter:(UIButton *)button
{
        [UIView animateWithDuration:1.0 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            RootTabBarViewController *rootabBarVC = [[RootTabBarViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = rootabBarVC;
        }];
        
}

- (void)clickClip:(UITapGestureRecognizer *)tap
{
    [self.enterButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(200));
    }];
}




- (void)playFinsihed
{
    [self.enterButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(200));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.moviePlayer.view layoutIfNeeded];
    }];
    
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [self.moviePlayer play];
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
