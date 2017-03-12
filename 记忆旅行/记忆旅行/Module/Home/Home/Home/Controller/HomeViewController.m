//
//  HomeViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "HomeViewController.h"
#import "JiangSegment.h"
#import "JiangPageView.h"
#import "VideoTagModel.h"
#import "VideoTagResultModel.h"
#import "VideoTagChildModel.h"
#import "HomeVideoList.h"
#import "Home_VideoListResult.h"
#import "CommonVideoTableViewCell.h"
#import "XLVideoPlayer.h"
#import "VideoDetailsViewController.h"
#import "LoginViewController.h"
#import "PersonalHomepageViewController.h"
#import "Home_Page_Update.h"
#import "SearchVideoController.h"
#import "SearchVideoResultController.h"
#import "HotWords.h"

@interface HomeViewController ()
<
JiangSegmentDelegate,
JiangPageViewDelegate,
JiangPageViewDataSource,
CommonViewoTableViewCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
UISearchControllerDelegate,
UISearchBarDelegate,
PYSearchViewControllerDelegate
>
@property (nonatomic, retain) UISearchController *searchController;

@property (nonatomic, strong) JiangSegment *segment;
@property (nonatomic, strong) JiangPageView *pageView;
@property (nonatomic, strong) VideoTagModel *videoTag;
@property (nonatomic, strong) HomeVideoList *homeVideoList;
@property (nonatomic, strong) NSMutableArray *tagNameArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *indexDidLoadArr;
@property (nonatomic, strong) NSMutableArray *allListDataArr;
@property (nonatomic, strong) XLVideoPlayer *player;
@property (nonatomic, strong) NSMutableArray *pageArr;
@property (nonatomic, strong) NSMutableArray *hotWordsArr;
@end

@implementation HomeViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    self.tabBarController.tabBar.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BTNGREENBG);
}

- (void)createSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.text = @"";
    _searchController.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 0, 100, 44);
    _searchController.searchBar.placeholder = @"搜索用户昵称";
    
    _searchController.searchBar.dk_tintColorPicker = DKColorPickerWithKey(BG);
    _searchController.searchBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    
}
- (void)didPresentSearchController:(UISearchController *)searchController {
    
}
- (void)getSearchWord {
    NSString *urlStr = @"http://www.yundao91.cn/ssh2/livideo?&cmd=getSerchWord";
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] integerValue] == 1) {
            if (_hotWordsArr.count > 0) {
                [_hotWordsArr removeAllObjects];
            }
            
            _hotWordsArr = [HotWords mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            if (_hotWordsArr.count > 0) {
                [_hotWordsArr removeAllObjects];
            }
            _hotWordsArr = [HotWords mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];

            
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // 1. 创建热门搜索
    NSMutableArray *array = [NSMutableArray array];
    for (HotWords *hotWord in _hotWordsArr) {
        [array addObject:hotWord.word];
    }
    NSArray *hotSeaches = array;
    SearchVideoController *searchVideoVC = [SearchVideoController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"查找相关视频"];
    self.hidesBottomBarWhenPushed = YES;
    searchVideoVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:searchVideoVC animated:NO];
    searchVideoVC.delegate = self;
    self.hidesBottomBarWhenPushed = NO;
    [self.searchController.searchBar resignFirstResponder];
    return YES;
}
// 点击热门
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index searchText:(NSString *)searchText {
    SearchVideoResultController *searchVideoResultVC = [[SearchVideoResultController alloc] init];
    searchVideoResultVC.searchName = searchText;
    searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController.navigationController pushViewController:searchVideoResultVC animated:YES];
}
// 点击取消
- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    [searchViewController.navigationController popViewControllerAnimated:NO];
}
// 点击搜索历史
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText {
    SearchVideoResultController *searchVideoResultVC = [[SearchVideoResultController alloc] init];
    searchVideoResultVC.searchName = searchText;
    searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController.navigationController pushViewController:searchVideoResultVC animated:YES];
}
// 点击搜索
- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText {
    SearchVideoResultController *searchVideoResultVC = [[SearchVideoResultController alloc] init];
    searchVideoResultVC.searchName = searchText;
    searchViewController.hidesBottomBarWhenPushed = YES;
    [searchViewController.navigationController pushViewController:searchVideoResultVC animated:YES];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
 
    
}





- (void)getSegmentTitleData {
    NSString *urlStr = [baseURL stringByAppendingString:@"/ssh2/livideo?&cmd=queryVideoTag&type=0"];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        self.tagNameArr = [NSMutableArray array];
        self.allListDataArr = [NSMutableArray array];
        self.videoTag = [VideoTagModel mj_objectWithKeyValues:responseObject];
        for (VideoTagResultModel *result in self.videoTag.result) {
            [_tagNameArr addObject:result.tagName];
            NSMutableArray *array = [NSMutableArray array];
            [_allListDataArr addObject:array];
            Home_Page_Update *page_Update = [[Home_Page_Update alloc] init];
            page_Update.page = 1;
            page_Update.isUpdate = NO;
            [_pageArr addObject:page_Update];
        }
        
        [self createSegmentAndPageView];
        
    } readCachesIfFailed:^(id responseObject) {
        self.tagNameArr = [NSMutableArray array];
        self.allListDataArr = [NSMutableArray array];
        self.videoTag = [VideoTagModel mj_objectWithKeyValues:responseObject];
        for (VideoTagResultModel *result in self.videoTag.result) {
            [_tagNameArr addObject:result.tagName];
            NSMutableArray *array = [NSMutableArray array];
            [_allListDataArr addObject:array];
            Home_Page_Update *page_Update = [[Home_Page_Update alloc] init];
            page_Update.page = 1;
            page_Update.isUpdate = NO;
            [_pageArr addObject:page_Update];
        }
        
        [self createSegmentAndPageView];
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
//        self.tagNameArr = [NSMutableArray array];
//        self.allListDataArr = [NSMutableArray array];
//        self.videoTag = [VideoTagModel mj_objectWithKeyValues:result];
//        for (VideoTagResultModel *result in self.videoTag.result) {
//            [_tagNameArr addObject:result.tagName];
//            NSMutableArray *array = [NSMutableArray array];
//            [_allListDataArr addObject:array];
//            Home_Page_Update *page_Update = [[Home_Page_Update alloc] init];
//            page_Update.page = 1;
//            page_Update.isUpdate = NO;
//            [_pageArr addObject:page_Update];
//        }
//        
//        [self createSegmentAndPageView];
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
}
- (void)getHomeVideoListDataWithIndex:(NSInteger)index {
    User *user = [User getUserInfo];
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    if (!userInfo) {
        userInfo.TEL = @"";
    }
    Home_Page_Update *page_Update = _pageArr[index];
    if (page_Update.isUpdate == NO) {
        // 如果下拉就清空所有数据
        [_allListDataArr[index] removeAllObjects];
    }
       NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    VideoTagResultModel *videoTagResult = [self.videoTag.result objectAtIndex:index];
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&videoTag=%@&browseUserID=%@&size=20&videoType=9&cmd=getAllLCVideoA&type=2&page=%ld&isOfficial=0", videoTagResult.ID, userInfo.TEL, page_Update.page]];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.homeVideoList = [HomeVideoList mj_objectWithKeyValues:responseObject];
        [self.allListDataArr[index] addObjectsFromArray:_homeVideoList.result];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tableView = [self.view viewWithTag:9000 + index];
            if (page_Update.isUpdate == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_homeVideoList.result.count % 20 != 0 || _homeVideoList.result.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

        
    } readCachesIfFailed:^(id responseObject) {
        self.homeVideoList = [HomeVideoList mj_objectWithKeyValues:responseObject];
        [self.allListDataArr[index] addObjectsFromArray:_homeVideoList.result];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tableView = [self.view viewWithTag:9000 + index];
            if (page_Update.isUpdate == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_homeVideoList.result.count % 20 != 0 || _homeVideoList.result.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });
        

        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
//       
//        self.homeVideoList = [HomeVideoList mj_objectWithKeyValues:result];
//        [self.allListDataArr[index] addObjectsFromArray:_homeVideoList.result];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        _tableView = [self.view viewWithTag:9000 + index];
//        if (page_Update.isUpdate == NO) {
//            _tableView.mj_footer.state = MJRefreshStateIdle;
//            [self.tableView.mj_header endRefreshing];
//        } else {
//            [self.tableView.mj_footer endRefreshing];
//            if (_homeVideoList.result.count % 20 != 0 || _homeVideoList.result.count == 0) {
//                
//                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//            }
//        }
//        
//        [_tableView reloadData];
//        });
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
//
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hotWordsArr = [NSMutableArray array];
    [self getSearchWord];
    [self createSearchController];
    self.navigationItem.titleView = _searchController.searchBar;
    self.indexDidLoadArr = [NSMutableArray array];
    self.pageArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self getSegmentTitleData];
}
- (void)createSegmentAndPageView {
    self.segment = [[JiangSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _segment.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
  
    [_segment updateChannels:_tagNameArr];
    _segment.delegate = self;
    self.selectedIndex = 1;
    [_segment didChangeToIndex:1];
    [self.view addSubview:_segment];
    self.pageView =[[JiangPageView alloc] initWithFrame:CGRectMake(0,_segment.height, SCREEN_WIDTH, self.view.bounds.size.height - _segment.y - _segment.height)];
    _pageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _pageView.datasource = self;
    _pageView.delegate = self;
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:1];
    [self.view addSubview:_pageView];
}

#pragma mark - JiangPageViewDataSource
- (NSInteger)numberOfItemInPageView:(JiangPageView *)pageView {
    return self.videoTag.result.count;
}

- (UIView *)pageView:(JiangPageView *)pageView viewAtIndex:(NSInteger)index{
    UITableView *tableView = [[UITableView alloc] initWithFrame:pageView.bounds style:UITableViewStyleGrouped];
    tableView.tag = 9000 + index;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        Home_Page_Update *page_Update = _pageArr[index];
        page_Update.page = 1;
        page_Update.isUpdate = NO;
        [_pageArr replaceObjectAtIndex:index withObject:page_Update];
        [self getHomeVideoListDataWithIndex:index];
    }];
    
    //上拉加载
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Home_Page_Update *page_Update = _pageArr[index];
        page_Update.page = page_Update.page + 1;
        page_Update.isUpdate = YES;
         [_pageArr replaceObjectAtIndex:index withObject:page_Update];
        [self getHomeVideoListDataWithIndex:index];
    }];

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
        
        if (index < _videoTag.result.count - 1) {
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
        return 50;
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
  static  NSString *const commonVideoCellIdentifier =  @"commonVideoCellIdentifier";
    CommonVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonVideoCellIdentifier];
    if (!cell) {
        cell = [[CommonVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonVideoCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *array = [NSMutableArray arrayWithArray:_allListDataArr[tableView.tag - 9000]];
    Home_VideoListResult *homeListResult = array[indexPath.section];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    [cell.videoBackImgBlurView addGestureRecognizer:tap];
    cell.videoBackImgBlurView.tag = indexPath.section + 8000;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.delegate = self;
    cell.homeListResult = homeListResult;
    return cell;
}



#pragma mark - 修改点赞状态和点赞数

- (void)voteChangedTableViewForCommonVideoCell:(CommonVideoTableViewCell *)cell {
    self.tableView = [self.view viewWithTag:9000 + _selectedIndex];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     Home_VideoListResult *homeListResult  = _allListDataArr[_selectedIndex][indexPath.section];
    
    if (homeListResult.isVote) {
        homeListResult.vote = [NSString stringWithFormat:@"%ld", [homeListResult.vote integerValue] - 1];
    } else {
        homeListResult.vote = [NSString stringWithFormat:@"%ld", [homeListResult.vote integerValue] + 1];
    }
    
    homeListResult.isVote = !homeListResult.isVote;
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)presentToLoginIfNot {
    [self showAlertActionLogin];
}


#pragma mark - 点击头像跳转
- (void)ClickHeadImageViewPushToPersonalVCWithArray:(NSMutableArray *)array type:(NSString *)type {
    if ([type isEqualToString:@"homeListResult"]) {

    PersonalHomepageViewController *personalHomePageVC = [[PersonalHomepageViewController alloc] init];
        Home_VideoListResult *listResult = array.firstObject;
    personalHomePageVC.touristID = listResult.TouristID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomePageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    }
}
#pragma mark - cell协议实现 点击评论跳转
- (void)ClickCommentPushToVCAndCommentWithArray:(NSMutableArray *)array type:(NSString *)type {
    if ([type isEqualToString:@"homeListResult"]) {
        
        self.hidesBottomBarWhenPushed = YES;
        VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
        videoDetailsVC.listResult = array.firstObject;
        videoDetailsVC.isComment = YES;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

}
#pragma mark - cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray arrayWithArray:_allListDataArr[tableView.tag - 9000]];
    Home_VideoListResult *listResult = array[indexPath.section];
    self.hidesBottomBarWhenPushed = YES;
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.listResult = listResult;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    

}
#pragma mark - 手势动作 显示播放器
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    UITableView *currentTableView = [self.view viewWithTag:_selectedIndex + 9000];
    UIView *view = tapGesture.view;
    NSMutableArray *array = [NSMutableArray arrayWithArray:_allListDataArr[_selectedIndex]];
    Home_VideoListResult *listResult = array[view.tag - 8000];
    
    NSIndexPath *_indexPath;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag - 8000];
    CommonVideoTableViewCell *cell = [currentTableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, listResult.videoPath];
    [_player playerBindTableView:currentTableView currentIndexPath:_indexPath];
    _player.frame = view.frame;
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        _player = nil;
    };
#pragma mark - 播放次数+1
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=ReviewsLCVideo&id=%@&num=1", listResult.ID]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSLog(@"播放次数+1");
        }

    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
