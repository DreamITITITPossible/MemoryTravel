//
//  SearchUserController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchUserController.h"
#import "RecommendModel.h"
#import "SearchUserCell.h"
#import "PersonalHomepageViewController.h"
@interface SearchUserController ()
<
UISearchResultsUpdating,
UISearchControllerDelegate,
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchUserArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *searchName;

// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation SearchUserController
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _searchController.active = YES;
}
- (void)didPresentSearchController:(UISearchController *)searchController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchController.searchBar becomeFirstResponder];
        
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
    _searchName = @"";
    self.searchUserArr = [NSMutableArray array];
    self.page = 1;
    [self getData];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}
- (void)getData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];

    
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/tour?&size=20&page=%ld&serchName=%@&cmd=queryNewUser&oneselfID=%@", _page, _searchName, userInfo.TEL]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_searchUserArr removeAllObjects];
        }
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSArray *resultArr = [result objectForKey:@"result"];
            NSArray *arr = [RecommendModel mj_objectArrayWithKeyValuesArray:resultArr];
            [_searchUserArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_searchUserArr.count % 20 != 0 || _searchUserArr.count == 0) {
                    
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
    return 70;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchUserArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *const cellIdentifier = @"searchUserCell";
    SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    RecommendModel *model = _searchUserArr[indexPath.row];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recommend = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalHomepageViewController *personalHomepageVC = [[PersonalHomepageViewController alloc] init];
    RecommendModel *model = _searchUserArr[indexPath.row];
    personalHomepageVC.touristID = model.TouristID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomepageVC animated:YES];
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
