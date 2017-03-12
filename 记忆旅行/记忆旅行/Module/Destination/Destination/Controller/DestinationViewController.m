//
//  DestinationViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "DestinationViewController.h"
#import "HeadLineView.h"
#import "CarouselView.h"
#import "ScenicSpotsCell.h"
#import "CarouselModel.h"
#import "HeaderTitleModel.h"
#import "ScenicSpotsModel.h"
#import "SceInfoViewController.h"
#import "SearchSpotController.h"
@interface DestinationViewController ()
<
HeadLineDelegate,
CarouselViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) CarouselView *carouselView;
@property (nonatomic, strong) HeadLineView *headLineView;//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *carouselImageURLArray;
@property (nonatomic, strong) NSMutableArray *carouselArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *listArray1;
@property (nonatomic, strong) NSMutableArray *listArray2;
@property (nonatomic, strong) NSMutableArray *listArray3;

@end

@implementation DestinationViewController
- (void)initdata {
    self.listArray1 = [NSMutableArray array];
    self.listArray2 = [NSMutableArray array];
    self.listArray3 = [NSMutableArray array];
    self.currentIndex = 0;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initdata];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"目的地"];;
    UIBarButtonItem *searchItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_search" HighLightedImageName:@"nav_search" Size:CGSizeMake(21, 21) targetBlock:^{
        SearchSpotController *searchSpotVC = [[SearchSpotController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchSpotVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];

    self.navigationItem.rightBarButtonItem = searchItem;
    [self getCarouselData];
    [self getHeadLineData];
    [self getScenicSpotsListData];
    [self createTableView];

}
- (void)getCarouselData {
    self.carouselArray = [NSMutableArray array];
    self.carouselImageURLArray = [NSMutableArray array];
    NSString *urlStr = @"http://www.yundao91.cn/ssh2/operation?&cmd=querySubJectByApp&typeID=1";
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                CarouselModel *carousel = [CarouselModel mj_objectWithKeyValues:dic];
                NSString *strPicUrl = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", carousel.typePicUrl];
                [_carouselArray addObject:carousel];
                [_carouselImageURLArray addObject:strPicUrl];
            }
            _carouselView.bannerImageArray = _carouselImageURLArray;
        }

        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                CarouselModel *carousel = [CarouselModel mj_objectWithKeyValues:dic];
                NSString *strPicUrl = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", carousel.typePicUrl];
                [_carouselArray addObject:carousel];
                [_carouselImageURLArray addObject:strPicUrl];
            }
            _carouselView.bannerImageArray = _carouselImageURLArray;
        }

        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                CarouselModel *carousel = [CarouselModel mj_objectWithKeyValues:dic];
//                NSString *strPicUrl = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", carousel.typePicUrl];
//                [_carouselArray addObject:carousel];
//                [_carouselImageURLArray addObject:strPicUrl];
//            }
//            _carouselView.bannerImageArray = _carouselImageURLArray;
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];

}

- (void)getHeadLineData {
    self.titleArray = [NSMutableArray array];
    NSString *urlStr = @"http://www.yundao91.cn/ssh2/operation?&cmd=queryTerminiTag";
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            HeaderTitleModel *headerTitle = [HeaderTitleModel mj_objectWithKeyValues:dic];
            [_titleArray addObject:headerTitle.oneTitle];
            [_titleArray addObject:headerTitle.twoTitle];
            [_titleArray addObject:headerTitle.threeTitle];
            
        }
        [_headLineView setTitleArray:_titleArray];
    } readCachesIfFailed:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            HeaderTitleModel *headerTitle = [HeaderTitleModel mj_objectWithKeyValues:dic];
            [_titleArray addObject:headerTitle.oneTitle];
            [_titleArray addObject:headerTitle.twoTitle];
            [_titleArray addObject:headerTitle.threeTitle];
            
        }
        [_headLineView setTitleArray:_titleArray];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSDictionary *dic = [result objectForKey:@"result"];
//            HeaderTitleModel *headerTitle = [HeaderTitleModel mj_objectWithKeyValues:dic];
//            [_titleArray addObject:headerTitle.oneTitle];
//            [_titleArray addObject:headerTitle.twoTitle];
//            [_titleArray addObject:headerTitle.threeTitle];
//            
//        }
//        [_headLineView setTitleArray:_titleArray];
//
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
    

}
- (void)getScenicSpotsListData {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/operation?&cmd=queryAllSceTermini&type=%ld", _currentIndex + 1];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            switch (_currentIndex) {
                case 0:
                    if (_listArray1.count > 0) {
                        [_listArray1 removeAllObjects];
                    }
                    break;
                case 1:
                    if (_listArray2.count > 0) {
                        [_listArray2 removeAllObjects];
                    }
                    break;
                case 2:
                    if (_listArray3.count > 0) {
                        [_listArray3 removeAllObjects];
                    }
                    break;
                default:
                    break;
            }
            
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                ScenicSpotsModel *scenicSpotsModel = [ScenicSpotsModel mj_objectWithKeyValues:dic];
                switch (_currentIndex) {
                    case 0:
                        [_listArray1 addObject:scenicSpotsModel];
                        break;
                    case 1:
                        [_listArray2 addObject:scenicSpotsModel];
                        
                        break;
                    case 2:
                        [_listArray3 addObject:scenicSpotsModel];
                        
                        break;
                    default:
                        break;
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            
        });

    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            switch (_currentIndex) {
                case 0:
                    if (_listArray1.count > 0) {
                        [_listArray1 removeAllObjects];
                    }
                    break;
                case 1:
                    if (_listArray2.count > 0) {
                        [_listArray2 removeAllObjects];
                    }
                    break;
                case 2:
                    if (_listArray3.count > 0) {
                        [_listArray3 removeAllObjects];
                    }
                    break;
                default:
                    break;
            }
            
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                ScenicSpotsModel *scenicSpotsModel = [ScenicSpotsModel mj_objectWithKeyValues:dic];
                switch (_currentIndex) {
                    case 0:
                        [_listArray1 addObject:scenicSpotsModel];
                        break;
                    case 1:
                        [_listArray2 addObject:scenicSpotsModel];
                        
                        break;
                    case 2:
                        [_listArray3 addObject:scenicSpotsModel];
                        
                        break;
                    default:
                        break;
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            switch (_currentIndex) {
//                case 0:
//                    if (_listArray1.count > 0) {
//                        [_listArray1 removeAllObjects];
//                    }
//                    break;
//                case 1:
//                    if (_listArray2.count > 0) {
//                        [_listArray2 removeAllObjects];
//                    }
//                    break;
//                case 2:
//                    if (_listArray3.count > 0) {
//                        [_listArray3 removeAllObjects];
//                    }
//                    break;
//                default:
//                    break;
//            }
//
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                ScenicSpotsModel *scenicSpotsModel = [ScenicSpotsModel mj_objectWithKeyValues:dic];
//                switch (_currentIndex) {
//                    case 0:
//                        [_listArray1 addObject:scenicSpotsModel];
//                        break;
//                    case 1:
//                        [_listArray2 addObject:scenicSpotsModel];
//
//                        break;
//                    case 2:
//                        [_listArray3 addObject:scenicSpotsModel];
//
//                        break;
//                    default:
//                        break;
//                }
//            }
//
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.tableView.mj_header endRefreshing];
//            [_tableView reloadData];
//            
//        });
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];

    
}
//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
        self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    [_tableView setTableHeaderView:[self carouselView]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getCarouselData];
        [self getHeadLineData];
        [self getScenicSpotsListData];
    }];
    

}
- (CarouselView *)carouselView {
    if (!_carouselView) {
        self.carouselView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];

           }
    _carouselView.delegate = self;
    return _carouselView;
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex > 1) {
            return;
        }
        _currentIndex++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex<=0) {
            return;
        }
        _currentIndex--;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self getScenicSpotsListData];

}

//头视图


#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex == 0) {
       return _listArray1.count;
    }else if(_currentIndex == 1){
        return _listArray2.count;
    }else{
        return _listArray3.count;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
        _headLineView = [[HeadLineView alloc]init];
        _headLineView.dk_tintColorPicker = DKColorPickerWithKey(BG);
        _headLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        _headLineView.delegate = self;
    }
    //如果headLineView需要添加图片，请到HeadLineView.m中去设置就可以了，里面有注释
    
    return _headLineView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个静态标识符  来给每一个cell 加上标记  方便我们从复用队列里面取到 名字为该标记的cell
  static   NSString *const reusID = @"ScenicSpots";
    //我创建一个cell 先从复用队列dequeue 里面 用上面创建的静态标识符来取
    
    ScenicSpotsCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
    //做一个if判断  如果没有cell  我们就创建一个新的 并且 还要给这个cell 加上复用标识符
    if (cell == nil) {
        cell=[[ScenicSpotsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusID];
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_currentIndex == 0) {
        cell.scenicSpots = _listArray1[indexPath.row];
        return cell;
        
    }else if(_currentIndex == 1){
        cell.scenicSpots = _listArray2[indexPath.row];
        return cell;
    }else {
        cell.scenicSpots = _listArray3[indexPath.row];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SceInfoViewController *sceInfoVC = [[SceInfoViewController alloc] init];
    if (_currentIndex == 0) {
        sceInfoVC.scenicSpots = _listArray1[indexPath.row];
        
    }else if(_currentIndex == 1){
        sceInfoVC.scenicSpots = _listArray2[indexPath.row];
    }else {
        sceInfoVC.scenicSpots = _listArray3[indexPath.row];
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sceInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
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
