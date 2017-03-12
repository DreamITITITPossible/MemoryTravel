//
//  SearchVideoResultController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/2.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchVideoResultController.h"
#import "SearchVideoCell.h"
#import "SceVideoModel.h"
#import "PersonalHomepageViewController.h"
#import "VideoDetailsViewController.h"

@interface SearchVideoResultController ()
<
UISearchResultsUpdating,
UISearchControllerDelegate,
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource,
SearchVideoCellDelegate
>
@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) NSMutableArray *searchVideoArr;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation SearchVideoResultController
- (void)createSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.text = _searchName;
    _searchController.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 0, 100, 44);
    _searchController.searchBar.placeholder = @"搜索视频";
    _searchController.searchBar.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    _searchController.searchBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _searchController.active = YES;
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
    //    NSString *searchString = _searchController.searchBar.text;
    //    NSLog(@"%@", searchString);
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
}

#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchName = searchBar.text;
    //    self.searchController.active = NO;
    [self.tableView.mj_header beginRefreshing];
    
    _isUpState = NO;
    [self getData];
    [self.searchController.searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    [self createSearchController];
    self.navigationItem.titleView = _searchController.searchBar;
    self.searchVideoArr = [NSMutableArray array];
    self.page = 1;
    [self getData];
    
    [self createTableView];

    [self createHeadView];
    // Do any additional setup after loading the view.
}
- (void)createHeadView {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    _headerLabel.text = [NSString stringWithFormat:@"搜索到%ld条视频", _searchVideoArr.count];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _headerLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _headerLabel.font = [UIFont systemFontOfSize:14];
    _tableView.tableHeaderView.frame = _headerLabel.frame;
    _tableView.tableHeaderView = _headerLabel;

}
- (void)setSearchName:(NSString *)searchName {
    if (_searchName != searchName) {
        _searchName = searchName;
    }
    
}
- (void)getData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&word=%@&size=20&cmd=retrieval&page=%ld", _searchName, _page];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_searchVideoArr removeAllObjects];
        }
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSArray *resultArr = [result objectForKey:@"result"];
            NSArray *arr = [SceVideoModel mj_objectArrayWithKeyValuesArray:resultArr];
            [_searchVideoArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerLabel.text = [NSString stringWithFormat:@"搜索到%ld条视频", _searchVideoArr.count];
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_searchVideoArr.count % 20 != 0 || _searchVideoArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        
    }];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //下拉刷新
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getData];
    }];
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getData];
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
       return [UIView new];
    
}
- (void)ClickSearchHeadImageViewPushToPersonalVCWithArray:(NSMutableArray *)array type:(NSString *)type {
    PersonalHomepageViewController *personalHomePageVC = [[PersonalHomepageViewController alloc] init];
    SceVideoModel *sceVideo = array.firstObject;
    personalHomePageVC.touristID = sceVideo.TouristID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomePageVC animated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchVideoArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *const cellIdentifier = @"SearchVideoCell";
    SearchVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    SceVideoModel *model = _searchVideoArr[indexPath.row];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sceVideo = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SceVideoModel *sceVideo = _searchVideoArr[indexPath.row];
    if ([sceVideo.videoType isEqualToString:@"1"]) {
        
    } else {

    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    videoDetailsVC.sceVideo = sceVideo;
    self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
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
