//
//  PersonalHomepageViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "PersonalHomepageViewController.h"
#import "PersonalInfo.h"
#import "PersonalHomepageHeaderView.h"
#import "WaveImageView.h"
#import "PersonalList.h"
#import "PersonlVideoCell.h"
#import "XLVideoPlayer.h"
#import "VideoDetailsViewController.h"
#import "Attention_FansViewController.h"
#import "PersonPicCell.h"
static CGFloat const imageHeight = 200;

@interface PersonalHomepageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
PersonalVideoCellDelegate,
HeaderViewDelegate,
PersonalPicCellDelegate
>
@property (nonatomic, strong) PersonalHomepageHeaderView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PersonalInfo *personalInfo;
@property (nonatomic, strong) WaveImageView *waveImageView;
@property (nonatomic, strong) NSMutableArray *listArray;
/** 是否正在播放动画 */
@property (nonatomic, assign, getter=isShowWave) BOOL showWave;
@property (nonatomic, strong) XLVideoPlayer *player;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UserInfo *userInfo;
// 标记上下的刷新
//@property (nonatomic, assign) BOOL isUpState;
@end

@implementation PersonalHomepageViewController
- (void)dealloc {
    _headView.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
    [_player destroyPlayer];
    _player = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.userInfo = [UserInfo getUserDetailsInfomation];
    NSString *title;
    if ([_userInfo.TourID isEqualToString:_touristID]) {
        title = @"Wo的主页";
    } else {
        title = @"Ta的主页";
    }
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:title];;
    self.page = 1;
    self.listArray = [NSMutableArray array];
    [self getPersonalInfo];
    [self getListData];
    [self judgeData];
    [self createTableView];
    [self setupHeaderView];
    if (![_userInfo.TourID isEqualToString:_touristID]) {
        
        [self createBottomBtn];
    }
    
}
- (void)createBottomBtn {
    
    self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 40 - 64, SCREEN_WIDTH, 40);
    [_attentionBtn setImage:[UIImage imageNamed:@"attention_no"] forState:UIControlStateNormal];
    [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionBtn setTitleColor: [UIColor colorWithRed:184 / 255.0 green:235 / 255.0 blue:228 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_attentionBtn setImage:[UIImage imageNamed:@"attention_yes"] forState:UIControlStateSelected];
    [_attentionBtn setTitleColor: [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1.0] forState:UIControlStateSelected];
    [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    _attentionBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.view addSubview:_attentionBtn];
}
- (void)setIsAttention:(BOOL)isAttention {
    if (_isAttention != isAttention) {
        _isAttention = isAttention;
    }
    if (_isAttention == 0) {
        _attentionBtn.selected = NO;
    } else {
        _attentionBtn.selected = YES;
    }
    
    
    [_attentionBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
#pragma mark - 关注
            NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
            if (_attentionBtn.selected == 0) {
                
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/userinfo"];
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=addfocus&in=%@", _touristID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        _attentionBtn.selected = !_attentionBtn.selected;
                        _attentionBtn.layer.borderColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1.0].CGColor;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消关注
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/userinfo"];
                
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=delfocus&out=%@", _touristID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        _attentionBtn.selected = !_attentionBtn.selected;
                        _attentionBtn.layer.borderColor = [UIColor colorWithRed:184 / 255.0 green:235 / 255.0 blue:228 / 255.0 alpha:1.0].CGColor;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self showAlertActionLogin];
        }
        
    }];
    
    
}

- (void)getPersonalInfo {
    User *user = [User getUserInfo];
    
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@/ssh2/tour?&cmd=queryPersonalInfor&tel=%@&st=123", baseURL, self.touristID];
    
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            
            
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
        }

        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
   
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//               self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[result objectForKey:@"result"]];
//          
//            
//        }
//    } failure:^(NSError *error) {
//
//        
//    }];
    
}
- (void)getListData {
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@/ssh2/userinfo?&browseUserID=%@&cmd=queryUserVideoAndPic&page=%ld&size=20&tel=%@", baseURL, userInfo.TEL, _page, self.touristID];
   
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                NSArray *array = [responseObject objectForKey:@"result"];
                for (NSDictionary *dic in array) {
                    PersonalList *list = [PersonalList mj_objectWithKeyValues:dic];
                    [self.listArray addObject:list];
                }
            } dispatch_async(dispatch_get_main_queue(), ^{
              
                [self.tableView.mj_footer endRefreshing];
                if (_listArray.count % 20 != 0 || _listArray.count == 0) {
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                [_tableView reloadData];
            });

        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                PersonalList *list = [PersonalList mj_objectWithKeyValues:dic];
                [self.listArray addObject:list];
            }
        } dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_footer endRefreshing];
            if (_listArray.count % 20 != 0 || _listArray.count == 0) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [_tableView reloadData];
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
    }];

    
    
    
    
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
////        if (_isUpState == NO) {
////            [_listArray removeAllObjects];
////        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                PersonalList *list = [PersonalList mj_objectWithKeyValues:dic];
//                [self.listArray addObject:list];
//            }
//        } dispatch_async(dispatch_get_main_queue(), ^{
////            if (_isUpState == NO) {
////                _tableView.mj_footer.state = MJRefreshStateIdle;
////                [self.tableView.mj_header endRefreshing];
////            } else {
//                [self.tableView.mj_footer endRefreshing];
//                if (_listArray.count % 20 != 0 || _listArray.count == 0) {
//                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
////            }
//            [_tableView reloadData];
//        });
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
    
}
- (void)judgeData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};

#pragma mark - 是否关注
    
    NSString *attentionUrlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/userinfo?&cmd=hf&tid=%@", _touristID]];
    [JYXNetworkingTool getWithUrl:attentionUrlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.isAttention = YES;
        } else {
            self.isAttention = NO;
        }

        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.isAttention = YES;
        } else {
            self.isAttention = NO;
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
    }];
//    HttpClient *attentionHttpClient = [[HttpClient alloc] init];
//    [attentionHttpClient GET:attentionUrlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.isAttention = YES;
//        } else {
//            self.isAttention = NO;
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
}

- (void)setTouristID:(NSString *)touristID {
    if (_touristID != touristID) {
        _touristID = touristID;
    }
    
}

- (void)createTableView {
    CGFloat height;
    if ([self.userInfo.TourID isEqualToString:_touristID]) {
        height = self.view.frame.size.height;
    } else {
        height = self.view.frame.size.height - 40;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, height ) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //    _tableView.y = -20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
        [self.view addSubview:_tableView];
    
    //下拉刷新
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.page = 1;
//        _isUpState = NO;
//        [self getPersonalInfo];
//        [self getListData];
//    }];
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _isUpState = YES;
        self.page = _page + 1;
        [self getListData];
    }];

    
}

- (void)setupHeaderView
{
    self.waveImageView = [[WaveImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
    _waveImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    [_tableView addSubview:_waveImageView];
  
    _headView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    
    self.headView = [[PersonalHomepageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 351 + 16)];
//    _headView.delegate = self;
    _headView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    _headView.clipsToBounds = YES;
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    _headView.clipsToBounds = YES;
    _tableView.tableHeaderView = _headView;
    _tableView.tableHeaderView.frame = _headView.frame;

    // 与图像高度一样防止数据被遮挡
 
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , _waveImageView.height)];
    
}
#pragma mark - 修改点赞状态和点赞数
- (void)voteChangedTableViewForPicCell:(PersonPicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PersonalList *listObject = _listArray[indexPath.section];
        if (listObject.vo.isVote) {
            listObject.vo.UserPictureVo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.UserPictureVo.vote integerValue] - 1];
        } else {
            listObject.vo.UserPictureVo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.UserPictureVo.vote integerValue] + 1];
        }

    listObject.vo.isVote = !listObject.vo.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)voteChangedTableViewForVideoCell:(PersonlVideoCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PersonalList *listObject = _listArray[indexPath.section];
    if (listObject.vo.isVote) {
        listObject.vo.cameraVideoVo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.UserPictureVo.vote integerValue] - 1];
    } else {
        listObject.vo.cameraVideoVo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.UserPictureVo.vote integerValue] + 1];
    }
    listObject.vo.isVote = !listObject.vo.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - 点击关注或粉丝事先协议
- (void)ClickFans_AttentionBtnPushToVCWithType:(NSString *)type TouristID:(NSString *)touristID {
    self.hidesBottomBarWhenPushed = YES;
    Attention_FansViewController *attention_FansVC = [[Attention_FansViewController alloc] init];
    attention_FansVC.type = type;
    attention_FansVC.touristID = touristID;
    if ([type isEqualToString:@"1"]) {
        attention_FansVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"Ta的关注"];
    } else {
        attention_FansVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"Ta的粉丝"];
    }
    [self.navigationController pushViewController:attention_FansVC animated:YES];
}
- (void)setPersonalInfo:(PersonalInfo *)personalInfo {
    if (_personalInfo != personalInfo) {
        _personalInfo = personalInfo;
    }
    NSLog(@"%f", _headView.height);
    _headView.personalInfo = _personalInfo;
    CGFloat signatureHeight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 50) title:_personalInfo.kidneyname font:kFONT_SIZE_13];
    CGFloat headerHeight = 200 + 44 + 20 + 10 + signatureHeight + 3 + 20 + 10 + 1 + 1 + 40 + 1 + 1
    ;

    _headView.height = headerHeight;
    
//    [_tableView beginUpdates];
    _tableView.tableHeaderView = _headView;
    _tableView.tableHeaderView.frame = _headView.frame;

    NSLog(@"%f", _tableView.tableHeaderView.height);

    NSLog(@"%f", _headView.height);
//    [_tableView endUpdates];
    
    
    [_waveImageView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", _personalInfo.Photo]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    _waveImageView.image = [_waveImageView.image boxblurImageWithBlur:0.65];

}
#pragma mark - 跳转到个人信息

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _listArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalList *listObject = _listArray[indexPath.section];
    CGFloat rowHeight;
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:listObject.vo.title font:[UIFont systemFontOfSize:16]];
     if ([listObject.type integerValue] == 1) {
         NSInteger count = listObject.vo.UserPictureVo.picList.count;
         CGFloat picHeight;
         if (count < 4) {
             picHeight = (SCREEN_WIDTH - 30) / 3;
         } else if (count >= 4 && count < 7) {
             picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
         } else {
             picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
         }
         
         rowHeight = 5 + 15 + 5 + titleHight + 10 + picHeight + 10 + 24 + 10;
   } else {
       CGFloat playerHeight;
       if ([listObject.vo.cameraVideoVo.videoWidth integerValue] < [listObject.vo.cameraVideoVo.videoHeight integerValue]) {
           
           playerHeight = 360;
       } else {
           playerHeight = (SCREEN_WIDTH - 40) * 9 / 16;
       }
       
       rowHeight = 5 + 15 + 5 + titleHight + 10 + playerHeight + 10 + 24 + 10;
         }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalList *listObject = _listArray[indexPath.section];
    if ([listObject.type integerValue] == 1) {
        static NSString *const PicCellID = @"PersonaolPicCell";
        PersonPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:PicCellID];
        if (!picCell) {
            picCell = [[PersonPicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PicCellID WithPicCount:listObject.vo.picList.count];
        }
        picCell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        picCell.personalList = listObject;
        picCell.delegate = self;
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return picCell;
    }
    static NSString *const ID = @"PersonalVideoCell";
    PersonlVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PersonlVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.personalList = listObject;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    cell.delegate = self;
    [cell.videoBackImgBlurView addGestureRecognizer:tap];
    cell.videoBackImgBlurView.tag = 7000 + indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - cell协议实现 点击评论跳转
- (void)ClickCommentPushToVCAndCommentWithListResult:(PersonalList *)listResult {
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.isComment = YES;
    videoDetailsVC.personalList = listResult;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalList *listObject = _listArray[indexPath.section];
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.isComment = YES;
    videoDetailsVC.personalList = listObject;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
    
}
- (void)presentPersonVideoToLoginIfNot {
    [self showAlertActionLogin];
}
- (void)presentPersonPicToLoginIfNot {
    [self showAlertActionLogin];
}

#pragma mark - 手势动作 显示播放器
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    UIView *view = tapGesture.view;
    PersonalList *listObject = _listArray[view.tag - 7000];
    
    NSIndexPath *_indexPath;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag - 7000];
    PersonlVideoCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, listObject.vo.cameraVideoVo.videoPath];
    [_player playerBindTableView:_tableView currentIndexPath:_indexPath];
    _player.frame = view.frame;
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        _player = nil;
    };
#pragma mark - 播放次数+1
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=ReviewsLCVideo&id=%@&num=1", listObject.vo.cameraVideoVo.ID]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSLog(@"播放次数+1");
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.isShowWave) {
        [self.waveImageView starWave];
    }
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //    NSLog(@"%f", fabs(offsetY));
    if (fabs(offsetY) > 20) {
        self.showWave = YES;
    }
    else {
        self.showWave = NO;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.waveImageView stopWave];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect tempF = self.waveImageView.frame;
    //     如果offsetY大于0，说明是向上滚动，缩小
    if (offsetY > 0) {
        _waveImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageHeight);
        //        NSLog(@"%f", _waveImageView.y);
        //        NSLog(@"%f", _tableView.y);
        //        _tableView.y = -64;
        
    }else{
        // 如果offsetY小于0，让headImageView的Y值等于0，headImageView的高度要放大
        tempF.size.height = imageHeight - offsetY;
        //        NSLog(@"%f", tempF.size.height);
        
        tempF.origin.y = 0 + offsetY;
        //        NSLog(@"%f", tempF.origin.y);
        
        self.waveImageView.frame = tempF;
    }
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);

    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
   
    
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
