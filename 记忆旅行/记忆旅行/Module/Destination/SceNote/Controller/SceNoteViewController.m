//
//  SceNoteViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceNoteViewController.h"
#import "SceNoteCell.h"
#import "SceNoteModel.h"
#import "SortDownListViewController.h"

@interface SceNoteViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SortDownListViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sceNoteArr;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation SceNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.sortVC.sortArray = @[@"全部", @"最新"];
    self.type = 2;
    self.page = 1;
    self.sceNoteArr = [NSMutableArray array];
    [self getSceNoteData];
    [self createTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - 排序

- (void)getSortInfomationWithSortNum:(NSInteger)sortNum {
    switch (sortNum) {
        case 0:
            _type = 2;
            
            break;
            
        default:
            _type = 1;
            break;
    }
    
    _page = 1;
    _isUpState = NO;
    [NSThread sleepForTimeInterval:0.2];
    [self.tableView.mj_header beginRefreshing];
    [self getSceNoteData];
       
    
}
- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    self.lon = array.firstObject;
    self.lat = array.lastObject;
    
}

- (void)getSceNoteData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/traceSce?&size=20&type=%ld&lat=%@&cmd=getLCTrace&lon=%@&page=%ld", _type,_lat, _lon, _page];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_sceNoteArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            NSArray *arr = [SceNoteModel mj_objectArrayWithKeyValuesArray:array];
            [_sceNoteArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_sceNoteArr.count % 20 != 0 || _sceNoteArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_tableView reloadData];
        });

    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_sceNoteArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            NSArray *arr = [SceNoteModel mj_objectArrayWithKeyValuesArray:array];
            [_sceNoteArr addObjectsFromArray:arr];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _tableView.mj_footer.state = MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (_sceNoteArr.count % 20 != 0 || _sceNoteArr.count == 0) {
                    
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
//            [_sceNoteArr removeAllObjects];
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            NSArray *arr = [SceNoteModel mj_objectArrayWithKeyValuesArray:array];
//            [_sceNoteArr addObjectsFromArray:arr];
//      
//        }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_isUpState == NO) {
//                    _tableView.mj_footer.state = MJRefreshStateIdle;
//                    [self.tableView.mj_header endRefreshing];
//                } else {
//                    [self.tableView.mj_footer endRefreshing];
//                    if (_sceNoteArr.count % 20 != 0 || _sceNoteArr.count == 0) {
//                        
//                        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                    }
//                }
//
//                [_tableView reloadData];
//            });
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //下拉刷新
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getSceNoteData];
    }];
    
//上拉加载

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getSceNoteData];
    }];

    [self.view addSubview:_tableView];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sceNoteArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const SceNoteID = @"SCeNoteIdentifier";
    SceNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:SceNoteID];
    if (!cell) {
        cell = [[SceNoteCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SceNoteID];
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sceNote = _sceNoteArr[indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
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
