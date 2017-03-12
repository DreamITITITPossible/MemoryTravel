//
//  TravelNotesViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "TravelNotesViewController.h"
#import "CommonPicCell.h"
#import "CommonVideoTableViewCell.h"
#import "Friends.h"
#import "VideoDetailsViewController.h"
#import "PersonalHomepageViewController.h"
#import "XLVideoPlayer.h"
#import "RecommendViewController.h"
#import "PopMenuView.h"
#import "IssuePicController.h"
#import "IssueVideoController.h"
@interface TravelNotesViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CommonPicCellDelegate,
CommonViewoTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *friendsArr;
@property (nonatomic, assign) BOOL isUpState;
@property (nonatomic, strong) XLVideoPlayer *player;

@end

@implementation TravelNotesViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    UIBarButtonItem *addFriendsItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_addFriends" HighLightedImageName:@"nav_addFriends" Size:CGSizeMake(21, 21) targetBlock:^{
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
        RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recommendVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } else {
            [self showAlertActionLogin];
        }
    }];
    self.navigationItem.rightBarButtonItem = addFriendsItem;
    self.friendsArr = [NSMutableArray array];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"好友动态"];
    [self getFriendsData];
    [self createTableView];
    
    UIButton *issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [issueBtn setBackgroundImage:[UIImage imageNamed:@"icon_issue"] forState:UIControlStateNormal];
//    [issueBtn setTitle:@"+" forState:UIControlStateNormal];
//    issueBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    issueBtn.showsTouchWhenHighlighted = NO;
    issueBtn.layer.cornerRadius = 25;
    issueBtn.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    issueBtn.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    issueBtn.layer.shadowRadius = 3;//阴影半径，默认3
    issueBtn.layer.shadowColor = JYXColor(64, 230, 208, 1).CGColor;
    issueBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    issueBtn.frame = CGRectMake(SCREEN_WIDTH - 75, SCREEN_HEIGHT - 64 - 49 - 100, 50, 50);
    [issueBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        
        issueBtn.highlighted = NO;
        [UIView animateWithDuration:0.5 animations:^{
                issueBtn.transform = CGAffineTransformMakeRotation(M_PI / 2);
        } completion:^(BOOL finished) {
            issueBtn.transform = CGAffineTransformIdentity;
            
            NSArray *imageArray = @[@"icon_issue_pic", @"icon_issue_video"];
            PopMenuView *popMenuView = [[PopMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ImageArray:imageArray didShareButtonBlock:^(NSInteger tag) {
                if (tag == 0) {
                    IssuePicController *issuePicVC = [[IssuePicController alloc] init];
                    
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:issuePicVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
            }];
         
            [popMenuView show];
          
        }];
        
        } else {
            [self showAlertActionLogin];
        }
    }];
    [self.view addSubview:issueBtn];
    // Do any additional setup after loading the view.
}
- (void)getFriendsData {
    User *user = [User getUserInfo];
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    if (user.isLogin == YES) {
        NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/msg?&browseUserID=%@&cmd=queryDynamic&page=%ld&size=20&tel=%@", userInfo.TEL, _page, userInfo.TEL];
        [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            if (_isUpState == NO) {
                // 如果下拉就清空所有数据
                [_friendsArr removeAllObjects];
            }
            
            if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                NSArray *array = [responseObject objectForKey:@"result"];
                NSArray *modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
                [_friendsArr addObjectsFromArray:modelArray];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isUpState == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                    if (_friendsArr.count % 20 != 0 || _friendsArr.count == 0) {
                        
                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                }
                
                [_tableView reloadData];
            });
            
            

            
        } readCachesIfFailed:^(id responseObject) {
            if (_isUpState == NO) {
                // 如果下拉就清空所有数据
                [_friendsArr removeAllObjects];
            }
            
            if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                NSArray *array = [responseObject objectForKey:@"result"];
                NSArray *modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
                [_friendsArr addObjectsFromArray:modelArray];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isUpState == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                    if (_friendsArr.count % 20 != 0 || _friendsArr.count == 0) {
                        
                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                }
                
                [_tableView reloadData];
            });
            
          

            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
//        
//        HttpClient *httpClient = [[HttpClient alloc] init];
//        [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//            if (_isUpState == NO) {
//                // 如果下拉就清空所有数据
//                [_friendsArr removeAllObjects];
//            }
//            
//            if ([[result objectForKey:@"flag"] isEqual:@1]) {
//                NSArray *array = [result objectForKey:@"result"];
//                NSArray *modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
//                [_friendsArr addObjectsFromArray:modelArray];
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_isUpState == NO) {
//                    _tableView.mj_footer.state = MJRefreshStateIdle;
//                    [self.tableView.mj_header endRefreshing];
//                } else {
//                    [self.tableView.mj_footer endRefreshing];
//                    if (_friendsArr.count % 20 != 0 || _friendsArr.count == 0) {
//                        
//                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                    }
//                }
//                
//                [_tableView reloadData];
//            });
//            
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];

    } else {
        NSLog(@"未登录");
    }
   
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);    //下拉刷新
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getFriendsData];
    }];
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getFriendsData];
    }];
    
    [self.view addSubview:_tableView];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return _friendsArr.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (void)presentToLoginIfNot {
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Friends *listObject = _friendsArr[indexPath.section];


    if ([listObject.type integerValue] == 1) {
        static NSString *const FriensPicID = @"FriensPicID";
        CommonPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:FriensPicID];
        if (!picCell) {
            picCell = [[CommonPicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FriensPicID];
        }
        picCell.friends = listObject;
        picCell.delegate = self;
        picCell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return picCell;
    }
    static NSString *const FriensVideoID = @"FriensVideoID";
    CommonVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriensVideoID];
    if (!cell) {
        cell = [[CommonVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FriensVideoID];
    }
    cell.friends = listObject;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    cell.delegate = self;
    [cell.videoBackImgBlurView addGestureRecognizer:tap];
    cell.videoBackImgBlurView.tag = 7000 + indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Friends *listObject = _friendsArr[indexPath.section];
    CGFloat rowHeight;
    CGFloat titleHight;
    if ([listObject.type integerValue] == 1) {
        NSInteger count = listObject.vo.picList.count;
        titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:listObject.vo.title font:[UIFont systemFontOfSize:16]];
        CGFloat picHeight;
        if (count < 4) {
            picHeight = (SCREEN_WIDTH - 30) / 3;
        } else if (count >= 4 && count < 7) {
            picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
        } else {
            picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
        }
        
        rowHeight = 10 + 40 + 10 + titleHight + 10 + picHeight + 10 + 24 + 10;
    } else {
        CGFloat playerHeight;
        titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:listObject.vo.videoName font:[UIFont systemFontOfSize:16]];

        if ([listObject.vo.videoWidth integerValue] < [listObject.vo.videoHeight integerValue]) {
            
            playerHeight = 360;
        } else {
            playerHeight = (SCREEN_WIDTH - 40) * 9 / 16;
        }
        
        rowHeight = 10 + 40 + 10 + titleHight + 10 + playerHeight + 10 + 24 + 10;
    }
    
    return rowHeight;
}
#pragma mark - 修改点赞状态和点赞数
- (void)voteChangedTableViewForCommonPicCell:(CommonPicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Friends *listObject = _friendsArr[indexPath.section];
    
    if (listObject.vo.isVote) {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] - 1];
    } else {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] + 1];
    }
    
    listObject.vo.isVote = !listObject.vo.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)voteChangedTableViewForCommonVideoCell:(CommonVideoTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Friends *listObject = _friendsArr[indexPath.section];
    
    if (listObject.vo.isVote) {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] - 1];
    } else {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] + 1];
    }
    
    listObject.vo.isVote = !listObject.vo.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - cell协议实现 点击评论跳转

- (void)ClickCommentPushToVCAndCommentWithArray:(NSMutableArray *)array type:(NSString *)type {
    if ([type isEqualToString:@"friends"]) {
        
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
        videoDetailsVC.isComment = YES;
        videoDetailsVC.friends = array.firstObject;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    }

}
- (void)ClickCommentPushToVCAndCommentWithFriend:(Friends *)friends {
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
        videoDetailsVC.isComment = YES;
        videoDetailsVC.friends = friends;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - cell协议实现 个人主页
- (void)ClickHeadImageViewPushToPersonalVCWithArray:(NSMutableArray *)array type:(NSString *)type {
    if ([type isEqualToString:@"friends"]) {
        
    PersonalHomepageViewController *perVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    Friends *friends = array.firstObject;
    perVC.touristID = friends.vo.TouristID;
    [self.navigationController pushViewController:perVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    }
    
}
- (void)ClickHeadImageViewPushToPersonalVCWithFriends:(Friends *)friends {
    PersonalHomepageViewController *perVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    perVC.touristID = friends.vo.TouristID;
    [self.navigationController pushViewController:perVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friends *listObject = _friendsArr[indexPath.section];
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.isComment = NO;
    videoDetailsVC.friends = listObject;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}


#pragma mark - 手势动作 显示播放器
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    UIView *view = tapGesture.view;
    Friends *listObject = _friendsArr[view.tag - 7000];
    
    NSIndexPath *_indexPath;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag - 7000];
    CommonVideoTableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, listObject.vo.videoPath];
    [_player playerBindTableView:_tableView currentIndexPath:_indexPath];
    _player.frame = view.frame;
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        _player = nil;
    };
#pragma mark - 播放次数+1
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=ReviewsLCVideo&id=%@&num=1", listObject.vo.ID]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSLog(@"播放次数+1");
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}








- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
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
