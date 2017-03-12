//
//  Attention_FansViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "Attention_FansViewController.h"
#import "Attention_FansModel.h"
#import "Attention_FansCell.h"
#import "PersonalHomepageViewController.h"
@interface Attention_FansViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
Attention_FansCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *attention_FansArr;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation Attention_FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

    self.attention_FansArr = [NSMutableArray array];
    self.page = 1;
    [self getData];
    [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)getData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
#pragma mark - 是否喜欢
   
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/userinfo?&size=20&tid=%@&type=%@&cmd=getrel&page=%ld", _touristID, _type, _page]];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_attention_FansArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *resultArr = [responseObject objectForKey:@"result"];
            NSArray *arr = [Attention_FansModel mj_objectArrayWithKeyValuesArray:resultArr];
            [_attention_FansArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_attention_FansArr.count % 20 != 0 || _attention_FansArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_attention_FansArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *resultArr = [responseObject objectForKey:@"result"];
            NSArray *arr = [Attention_FansModel mj_objectArrayWithKeyValuesArray:resultArr];
            [_attention_FansArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_attention_FansArr.count % 20 != 0 || _attention_FansArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if (_isUpState == NO) {
//            // 如果下拉就清空所有数据
//            [_attention_FansArr removeAllObjects];
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *resultArr = [result objectForKey:@"result"];
//            NSArray *arr = [Attention_FansModel mj_objectArrayWithKeyValuesArray:resultArr];
//            [_attention_FansArr addObjectsFromArray:arr];
//          
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_isUpState == NO) {
//                _tableView.mj_footer.state = MJRefreshStateIdle;
//                [self.tableView.mj_header endRefreshing];
//            } else {
//                [self.tableView.mj_footer endRefreshing];
//                if (_attention_FansArr.count % 20 != 0 || _attention_FansArr.count == 0) {
//                    
//                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//            }
//            
//            [_tableView reloadData];
//        });
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
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
    return _attention_FansArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static  NSString *const cellIdentifier = @"fanCell";
    Attention_FansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[Attention_FansCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    Attention_FansModel *model = _attention_FansArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.attention_FansModel = model;
    return cell;
}
- (void)presentAttention_FansToLoginIfNot {
    [self showAlertActionLogin];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalHomepageViewController *personalHomepageVC = [[PersonalHomepageViewController alloc] init];
    Attention_FansModel *model = _attention_FansArr[indexPath.row];
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
