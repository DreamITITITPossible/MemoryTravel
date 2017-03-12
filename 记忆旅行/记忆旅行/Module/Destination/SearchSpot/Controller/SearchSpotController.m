//
//  SearchSpotController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/4.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchSpotController.h"
#import "SearchSpotCell.h"
#import "ScenicSpotsModel.h"
#import "FilterDownListViewController.h"
#import "FilterModel.h"
#import "SearchSpot.h"
#import "SceInfoViewController.h"
@interface SearchSpotController ()
<
UITableViewDataSource,
UITableViewDelegate,
FilterDownListViewControllerDelegate,
UISearchResultsUpdating,
UISearchControllerDelegate,
UISearchBarDelegate
>
@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, retain) FilterDownListViewController *filterVC;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FilterModel *filter;
@property (nonatomic, copy) NSString *searchName;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation SearchSpotController
#pragma mark - 初始请求数据
- (void)defaultRequestData {
    self.filter = [[FilterModel alloc] init];
    _filter.provinceID = @"";
    _filter.cityID = @"";
    _filter.grade = @"";
    _searchName = @"";
    _page = 1;
    self.searchArr = [NSMutableArray array];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addChildViewController:_filterVC];
    [self.view addSubview:_filterVC.view];
    _searchController.active = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultRequestData];
    [self createSearchController];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.titleView = _searchController.searchBar;
    [self getSearchData];
    self.filterVC = [[FilterDownListViewController alloc] init];
    self.filterVC.segCArr = [[NSMutableArray alloc]initWithObjects:@"地区", @"等级", nil];
    _filterVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    _filterVC.delegate = self;
    [self createTableView];
    
}

- (void)createSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 0, 100, 44);
    _searchController.searchBar.placeholder = @"搜索用户昵称";
    _searchController.searchBar.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    _searchController.searchBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //下拉刷新
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getSearchData];
    }];
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getSearchData];
    }];
    
    
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.searchController.searchBar becomeFirstResponder];
        
    });
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchController.searchBar resignFirstResponder];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}

#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchName = searchBar.text;
    //    self.searchController.active = NO;
    [self.tableView.mj_header beginRefreshing];
    _isUpState = NO;
    [self getSearchData];
    [self.searchController.searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getSearchData {
    
    NSString *urlString =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/operation?&CityID=%@&ProvinceID=%@&listType=&sceName=%@&size=20&cmd=querySceAll&page=%ld&gradeID=%@", _filter.cityID, _filter.provinceID, _searchName, _page, _filter.grade];
    [JYXNetworkingTool getWithUrl:urlString params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_searchArr removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
        NSArray *array = [SearchSpot mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_searchArr addObjectsFromArray:array];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_searchArr.count % 20 != 0 || _searchArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_searchArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
               _searchArr = [SearchSpot mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_searchArr.count % 20 != 0 || _searchArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}


- (void)getFilterInfomationWithFilterModel:(FilterModel *)filter {
    _filter = filter;
    [self.tableView.mj_header beginRefreshing];
    _isUpState = NO;
    [self getSearchData];
}
- (void)clickSegResignFirstResponder {
    [_searchController.searchBar resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 5 * 2 / 4 * 3 + 10 + 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const searchSpotCellID = @"SearchSpotCellID";
    SearchSpotCell *cell = [tableView dequeueReusableCellWithIdentifier:searchSpotCellID];
    if (!cell) {
        cell = [[SearchSpotCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:searchSpotCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.searchSpot = _searchArr[indexPath.row];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SceInfoViewController *sceInfoVC = [[SceInfoViewController alloc] init];
    SearchSpot *searchSpot = _searchArr[indexPath.row];
    ScenicSpotsModel *scenicSpots = [[ScenicSpotsModel alloc] init];
    scenicSpots.picUrl = searchSpot.PicUrl;
//    scenicSpots.wantGo = searchSpot.
    scenicSpots.isLive = searchSpot.isLive;
    scenicSpots.remark = searchSpot.SceRemark;
    scenicSpots.ID = searchSpot.SceID;
//    scenicSpots.termini = searchSpot.
    scenicSpots.titleName = searchSpot.SceName;
    scenicSpots.showIndex = searchSpot.sceIndex;
    scenicSpots.allSceID = [NSString stringWithFormat:@"%@+%@", searchSpot.Longitude, searchSpot.Latitude];
    sceInfoVC.scenicSpots = scenicSpots;
 
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sceInfoVC animated:YES];

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
