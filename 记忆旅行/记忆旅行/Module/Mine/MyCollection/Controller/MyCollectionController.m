//
//  MyCollectionController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "MyCollectionController.h"
#import "JiangSegment.h"
#import "JiangPageView.h"
#import "TraceModel.h"
#import "CommonPicCell.h"
#import "CommonVideoTableViewCell.h"
#import "Friends.h"
#import "PersonalHomepageViewController.h"
#import "XLVideoPlayer.h"
#import "VideoDetailsViewController.h"
#import "Home_Page_Update.h"
@interface MyCollectionController ()
<
JiangSegmentDelegate,
JiangPageViewDelegate,
JiangPageViewDataSource,
UITableViewDelegate,
UITableViewDataSource,
CommonPicCellDelegate,
CommonViewoTableViewCellDelegate
>

@property (nonatomic, strong) JiangSegment *segment;
@property (nonatomic, strong) JiangPageView *pageView;
@property (nonatomic, strong) NSMutableArray *tagNameArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *indexDidLoadArr;
@property (nonatomic, strong) NSMutableArray *allListDataArr;
@property (nonatomic, strong) XLVideoPlayer *player;
@property (nonatomic, strong) NSMutableArray *pageArr;
@end

@implementation MyCollectionController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player destroyPlayer];
    _player = nil;
}
- (void)getSegmentTitleData {
 
        self.tagNameArr = [NSMutableArray arrayWithArray:@[@"旅图和视频", @"旅迹"]];
        self.allListDataArr = [NSMutableArray array];
        for (int i = 0; i <_tagNameArr.count; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [_allListDataArr addObject:array];
            Home_Page_Update *page_Update = [[Home_Page_Update alloc] init];
            page_Update.page = 1;
            page_Update.isUpdate = NO;
            [_pageArr addObject:page_Update];
        }
    [self createSegmentAndPageView];
        
 }
- (void)getHomeVideoListDataWithIndex:(NSInteger)index {
    User *user = [User getUserInfo];
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    if (!userInfo) {
        userInfo.TEL = @"";
    }
     NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    Home_Page_Update *page_Update = _pageArr[index];
    if (page_Update.isUpdate == NO) {
        // 如果下拉就清空所有数据
        [_allListDataArr[index] removeAllObjects];
    }
    NSString *urlStr;
    if (index == 0) {
        // 我收藏的图片和视频
        urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&size=20&tel=%@&cmd=getOnselVideoCollectLog&page=%ld", userInfo.TEL, page_Update.page]];
    } else {
        // 我收藏的旅迹
        urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/trac?&cmd=lookclet&tel=%@", userInfo.TEL]];

    }
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *modelArray;

        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            if (index == 0) {
                
                modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
                
                [self.allListDataArr[index] addObjectsFromArray:modelArray];
            } else {
                NSArray *traceArr = [TraceModel mj_objectArrayWithKeyValuesArray:array];
                
                [self.allListDataArr[index] addObjectsFromArray:traceArr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == 0) {
                
                _tableView = [self.view viewWithTag:9000 + index];
                if (page_Update.isUpdate == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                    if (modelArray.count % 20 != 0 || modelArray.count == 0) {
                        
                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                }
            } else {
                _tableView = [self.view viewWithTag:9000 + index];
                if (page_Update.isUpdate == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                }
            }
            
            [_tableView reloadData];
        });
        

        
    } readCachesIfFailed:^(id responseObject) {
        NSArray *modelArray;

        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            if (index == 0) {
                
                modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
                
                [self.allListDataArr[index] addObjectsFromArray:modelArray];
            } else {
                NSArray *traceArr = [TraceModel mj_objectArrayWithKeyValuesArray:array];
                
                [self.allListDataArr[index] addObjectsFromArray:traceArr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == 0) {
                
                _tableView = [self.view viewWithTag:9000 + index];
                if (page_Update.isUpdate == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                    if (modelArray.count % 20 != 0 || modelArray.count == 0) {
                        
                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    }
                }
            } else {
                _tableView = [self.view viewWithTag:9000 + index];
                if (page_Update.isUpdate == NO) {
                    _tableView.mj_footer.state = MJRefreshStateIdle;
                }
            }
            
            [_tableView reloadData];
        });
        
        
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//        HttpClient *httpClient = [[HttpClient alloc] init];
//        [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
//            NSArray *modelArray;
//            if ([[result objectForKey:@"flag"] isEqual:@1]) {
//                NSArray *array = [result objectForKey:@"result"];
//                if (index == 0) {
//                    
//                    modelArray = [Friends mj_objectArrayWithKeyValuesArray:array];
//                    
//                    [self.allListDataArr[index] addObjectsFromArray:modelArray];
//                } else {
//                    NSArray *traceArr = [TraceModel mj_objectArrayWithKeyValuesArray:array];
//                    
//                    [self.allListDataArr[index] addObjectsFromArray:traceArr];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (index == 0) {
//                    
//                _tableView = [self.view viewWithTag:9000 + index];
//                if (page_Update.isUpdate == NO) {
//                    _tableView.mj_footer.state = MJRefreshStateIdle;
//                    [self.tableView.mj_header endRefreshing];
//                } else {
//                    [self.tableView.mj_footer endRefreshing];
//                    if (modelArray.count % 20 != 0 || modelArray.count == 0) {
//                        
//                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                    }
//                }
//                } else {
//                    _tableView = [self.view viewWithTag:9000 + index];
//                    if (page_Update.isUpdate == NO) {
//                        _tableView.mj_footer.state = MJRefreshStateIdle;
//                    }
//                }
//
//                [_tableView reloadData];
//            });
//            
//        } failure:^(NSError *error) {
//            
//            
//            
//        }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.indexDidLoadArr = [NSMutableArray array];
    self.pageArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self getSegmentTitleData];
}
- (void)createSegmentAndPageView {
    self.segment = [[JiangSegment alloc] initWithFrame:CGRectMake(0, 0, 167, 44)];
        [_segment updateChannels:_tagNameArr];
    _segment.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _segment.delegate = self;
    self.selectedIndex = 0;
    [_segment didChangeToIndex:0];
    self.navigationItem.titleView = _segment;
    self.pageView =[[JiangPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _pageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    _pageView.datasource = self;
    _pageView.delegate = self;
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:0];
    [self.view addSubview:_pageView];
}

#pragma mark - JiangPageViewDataSource
- (NSInteger)numberOfItemInPageView:(JiangPageView *)pageView {
    return _tagNameArr.count;
}

- (UIView *)pageView:(JiangPageView *)pageView viewAtIndex:(NSInteger)index{
    UITableView *tableView = [[UITableView alloc] initWithFrame:pageView.bounds style:UITableViewStyleGrouped];
    tableView.tag = 9000 + index;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        Home_Page_Update *page_Update = _pageArr[index];
        page_Update.page = 1;
        page_Update.isUpdate = NO;
        [_pageArr replaceObjectAtIndex:index withObject:page_Update];
        [self getHomeVideoListDataWithIndex:index];
    }];
    
    //上拉加载
    if (index == 0) {
        
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Home_Page_Update *page_Update = _pageArr[index];
        page_Update.page = page_Update.page + 1;
        page_Update.isUpdate = YES;
        [_pageArr replaceObjectAtIndex:index withObject:page_Update];
        [self getHomeVideoListDataWithIndex:index];
    }];
    }
    
    return tableView;
}

#pragma mark - JiangSegmentDelegate
- (void)JiangSegment:(JiangSegment *)segment didSelectIndex:(NSInteger)index {
    [_pageView changeToItemAtIndex:index];
    [_player destroyPlayer];
    _player = nil;
    self.selectedIndex = index;
    if (![_indexDidLoadArr containsObject:[NSNumber numberWithInteger:index]]) {
        [self getHomeVideoListDataWithIndex:index];
        [_indexDidLoadArr addObject:[NSNumber numberWithInteger:index]];
    }
    if (index > 1) {
        if (![_indexDidLoadArr containsObject:[NSNumber numberWithInteger:index - 1]]) {
            [self getHomeVideoListDataWithIndex:index - 1];
            [_indexDidLoadArr addObject:[NSNumber numberWithInteger:index - 1]];
        } else {
            
        }
        
        if (index < _tagNameArr.count - 1) {
            if (![_indexDidLoadArr containsObject:[NSNumber numberWithInteger:index + 1]]) {
                [self getHomeVideoListDataWithIndex:index + 1];
                [_indexDidLoadArr addObject:[NSNumber numberWithInteger:index + 1]];
            } else {
                
            }
        }
    }
    
   
    
}

#pragma mark - JiangPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [_segment didChangeToIndex:index];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_allListDataArr[tableView.tag - 9000] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - 返回cell高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 9000) {
        Friends *listObject = _allListDataArr[_selectedIndex][indexPath.section];
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
    } else {
        Home_VideoListResult *resultData = [_allListDataArr[tableView.tag - 9000] objectAtIndex:indexPath.section];
        CGFloat height;
        CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:resultData.videoName font:kFONT_SIZE_18];
        CGFloat videoHeight;
        if ([resultData.videoWidth integerValue] < [resultData.videoHeight integerValue]) {
            videoHeight = 360;
        } else  {
            videoHeight = (SCREEN_WIDTH - 40) * 9 / 16;
        }
        height = 10 + 40 + 10 + titleHight + 10 + videoHeight + 10 + 24 + 10;
        return height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray arrayWithArray:_allListDataArr[tableView.tag - 9000]];
    if (tableView.tag == 9000) {
        Friends *listObject = array[indexPath.section];
        NSLog(@"%d", listObject.vo.isVote);
        if ([listObject.type integerValue] == 1) {
            static NSString *const FriensPicID = @"FriensPicID";
            CommonPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:FriensPicID];
            if (!picCell) {
                picCell = [[CommonPicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FriensPicID];
            }
            picCell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

            picCell.friends = listObject;
            picCell.delegate = self;
            picCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return picCell;
        } 
        static NSString *const FriensVideoID = @"FriensVideoID";
        CommonVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriensVideoID];
        if (!cell) {
            cell = [[CommonVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FriensVideoID];
        }
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        cell.friends = listObject;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
        cell.delegate = self;
        [cell.videoBackImgBlurView addGestureRecognizer:tap];
        cell.videoBackImgBlurView.tag = 7000 + indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    } else {
        
        return nil;
    }
    
    
    
}
#pragma mark - 修改点赞状态和点赞数
- (void)voteChangedTableViewForCommonPicCell:(CommonPicCell *)cell {
    self.tableView = [self.view viewWithTag:9000];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Friends *listObject = _allListDataArr[_selectedIndex][indexPath.section];

    if (listObject.vo.isVote) {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] - 1];
    } else {
        listObject.vo.vote = [NSString stringWithFormat:@"%ld", [listObject.vo.vote integerValue] + 1];
    }
    
    listObject.vo.isVote = !listObject.vo.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)voteChangedTableViewForCommonVideoCell:(CommonVideoTableViewCell *)cell {
    self.tableView = [self.view viewWithTag:9000];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Friends *listObject = _allListDataArr[_selectedIndex][indexPath.section];
    
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
    }
    
}
- (void)ClickCommentPushToVCAndCommentWithFriend:(Friends *)friends {
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.isComment = YES;
    videoDetailsVC.friends = friends;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
}
#pragma mark - cell协议实现 个人主页
- (void)ClickHeadImageViewPushToPersonalVCWithArray:(NSMutableArray *)array type:(NSString *)type {
    if ([type isEqualToString:@"friends"]) {
        
        PersonalHomepageViewController *perVC = [[PersonalHomepageViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        Friends *friends = array.firstObject;
        perVC.touristID = friends.vo.TouristID;
        [self.navigationController pushViewController:perVC animated:YES];
    }
    
}
- (void)ClickHeadImageViewPushToPersonalVCWithFriends:(Friends *)friends {
    PersonalHomepageViewController *perVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    perVC.touristID = friends.vo.TouristID;
    [self.navigationController pushViewController:perVC animated:YES];
}

#pragma mark - cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 9000) {
        
        Friends *listObject = _allListDataArr[_selectedIndex][indexPath.section];
        VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
        videoDetailsVC.isComment = NO;
        videoDetailsVC.friends = listObject;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
    }
    
    
}
#pragma mark - 手势动作 显示播放器
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    UIView *view = tapGesture.view;
 UITableView *currentTableView = [self.view viewWithTag:_selectedIndex + 9000];    Friends *listObject = _allListDataArr[_selectedIndex][view.tag - 7000];
    
    NSIndexPath *_indexPath;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag - 7000];
    CommonVideoTableViewCell *cell = [currentTableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, listObject.vo.videoPath];
    [_player playerBindTableView:currentTableView currentIndexPath:_indexPath];
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

    [_player playerScrollIsSupportSmallWindowPlay:YES];
    
    
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
