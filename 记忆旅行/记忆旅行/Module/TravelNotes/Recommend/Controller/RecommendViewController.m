//
//  RecommendViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "RecommendViewController.h"

#import "RecommendCell.h"
#import "RecommendModel.h"
#import "PersonalHomepageViewController.h"
#import "SearchUserController.h"
@interface RecommendViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recommendArr;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *searchItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_search" HighLightedImageName:@"nav_search" Size:CGSizeMake(21, 21) targetBlock:^{
        SearchUserController *searchUserVC = [[SearchUserController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchUserVC animated:YES];
        
    }];
     self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"新人推荐"];
    self.navigationItem.rightBarButtonItem = searchItem;
    self.recommendArr = [NSMutableArray array];
    self.page = 1;
    [self getData];
    [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)getData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    
    
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/tour?&size=20&page=%ld&cmd=queryNewUser&oneselfID=%@", _page, userInfo.TEL]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_recommendArr removeAllObjects];
        }
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSArray *resultArr = [result objectForKey:@"result"];
            NSArray *arr = [RecommendModel mj_objectArrayWithKeyValuesArray:resultArr];
            [_recommendArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_recommendArr.count % 20 != 0 || _recommendArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
        
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
    return _recommendArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *const recommendcellIdentifier = @"recommendCell";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendcellIdentifier];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recommendcellIdentifier];
    }
    RecommendModel *model = _recommendArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.recommend = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalHomepageViewController *personalHomepageVC = [[PersonalHomepageViewController alloc] init];
    RecommendModel *model = _recommendArr[indexPath.row];
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
