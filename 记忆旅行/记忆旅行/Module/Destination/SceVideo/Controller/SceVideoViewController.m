//
//  SceVideoViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceVideoViewController.h"
#import "SceVideoCell.h"
#import "SceVideoModel.h"
#import "PersonalHomepageViewController.h"
#import "VideoDetailsViewController.h"
#import "SortDownListViewController.h"

static NSString *const cellIdentifier = @"SceVideoCell";
@interface SceVideoViewController ()
<
SceVideoCellDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
SortDownListViewControllerDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, strong) NSMutableArray *sceVideoArr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger videoType;
@property (nonatomic, assign) NSInteger isOfficial;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end


@implementation SceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.type = 1;
    self.videoType = 0;
    self.isOfficial = 0;
    self.sortVC.sortArray = @[@"全部", @"热门", @"最新", @"官方", @"直播"];

    // Do any additional setup after loading the view.
    self.sceVideoArr = [NSMutableArray array];
    [self getSceVideoData];
    [self createCollectionView];
    
}
#pragma mark - 排序

- (void)getSortInfomationWithSortNum:(NSInteger)sortNum {
    switch (sortNum) {
        case 0:
            _isOfficial = 0;
            _type = 1;
            _videoType = 0;
            break;
        case 1:
            _isOfficial = 0;
            _type = 1;
            _videoType = 3;

            break;
        case 2:
            _isOfficial = 0;
            _type = 2;
            _videoType = 3;

            break;
        case 3:
            _isOfficial = 2;
            _type = 1;
            _videoType = 0;
            break;
        default:
            _isOfficial = 0;
            _type = 1;
            _videoType = 8;

            break;
            
    }
    _page = 1;
    [NSThread sleepForTimeInterval:0.2];
    [self.collectionView.mj_header beginRefreshing];
    _isUpState = NO;
    [self getSceVideoData];
    
    
}

- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    self.lon = array.firstObject;
    self.lat = array.lastObject;
    
}

- (void)getSceVideoData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&isOfficial=%ld&type=%ld&size=20&videoType=%ld&cmd=getLCVideoBySce&lat=%@&lon=%@&page=%ld&isMap=1", _isOfficial, _type, _videoType, _lat, _lon, _page];
   [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
       if (_isUpState == NO) {
           // 如果下拉就清空所有数据
           [_sceVideoArr removeAllObjects];
       }
       if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
           NSArray *array = [responseObject objectForKey:@"result"];
           for (NSDictionary *dic in array) {
               SceVideoModel *sceVideo = [SceVideoModel mj_objectWithKeyValues:dic];
               [_sceVideoArr addObject:sceVideo];
           }
           
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           if (_isUpState == NO) {
               [self.collectionView.mj_header endRefreshing];
               _collectionView.mj_footer.state = MJRefreshStateIdle;
           } else {
               [self.collectionView.mj_footer endRefreshing];
               
               if (_sceVideoArr.count % 20 != 0 || _sceVideoArr.count == 0) {
                   
                   self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
               }
               
           }
           
           [_collectionView reloadData];
           
       });
       

       
   } readCachesIfFailed:^(id responseObject) {
       if (_isUpState == NO) {
           // 如果下拉就清空所有数据
           [_sceVideoArr removeAllObjects];
       }
       if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
           NSArray *array = [responseObject objectForKey:@"result"];
           for (NSDictionary *dic in array) {
               SceVideoModel *sceVideo = [SceVideoModel mj_objectWithKeyValues:dic];
               [_sceVideoArr addObject:sceVideo];
           }
           
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           if (_isUpState == NO) {
               [self.collectionView.mj_header endRefreshing];
               _collectionView.mj_footer.state = MJRefreshStateIdle;
           } else {
               [self.collectionView.mj_footer endRefreshing];
               
               if (_sceVideoArr.count % 20 != 0 || _sceVideoArr.count == 0) {
                   
                   self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
               }
               
           }
           
           [_collectionView reloadData];
           
       });
       

   } failed:^(NSURLSessionDataTask *task, NSError *error) {
       
       
   }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if (_isUpState == NO) {
//            // 如果下拉就清空所有数据
//            [_sceVideoArr removeAllObjects];
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                SceVideoModel *sceVideo = [SceVideoModel mj_objectWithKeyValues:dic];
//                [_sceVideoArr addObject:sceVideo];
//            }
//           
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_isUpState == NO) {
//                [self.collectionView.mj_header endRefreshing];
//                _collectionView.mj_footer.state = MJRefreshStateIdle;
//            } else {
//                [self.collectionView.mj_footer endRefreshing];
//                
//                if (_sceVideoArr.count % 20 != 0 || _sceVideoArr.count == 0) {
//                    
//                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//
//            }
//            
//            [_collectionView reloadData];
//            
//        });
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // item的尺寸 (cell大小)
    //    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 15, SCREEN_WIDTH / 2 - 15 + 10 + 40 + 10 + 30);
    // 设置最小行间距 (默认是10)
    // 在垂直滑动情况下: 连续的行之间的间距
    // 在水平滑动情况下: 连续的列之间的间距
    flowLayout.minimumLineSpacing = 10;
    // 设置item之间最小间距 (默认是10)
    // 在垂直滑动情况下: 同一行之间item的间距
    // 在水平滑动情况下: 同一列之间item的间距
    flowLayout.minimumInteritemSpacing = 10;
    // 设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    
    
    
    // 创建集合视图
    // 需要提供一个布局对象
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(240, 240, 240, 1.0), [UIColor blackColor]);
    [self.view addSubview:_collectionView];
    // 只能使用注册的方式
    [_collectionView registerClass:[SceVideoCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.alwaysBounceVertical = YES;
    
    //下拉刷新
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getSceVideoData];
    }];
    
    
    
    //上拉加载
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getSceVideoData];
    }];
    
    

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_sceVideoArr.count != 0) {
        return _sceVideoArr.count;
    }
    return 0;
    
}
// 设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从重用池取cell
    SceVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.sceVideo = _sceVideoArr[indexPath.item];
    cell.delegate = self;
    
    return cell;
}
- (void)ClickHeadImageViewPushToPersonalVCWithSceVideoModel:(SceVideoModel *)sceVideo {
    PersonalHomepageViewController *personalVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    personalVC.touristID = sceVideo.TouristID;
    [self.navigationController pushViewController:personalVC animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SceVideoModel *sceVideo = _sceVideoArr[indexPath.item];
    if ([sceVideo.videoType isEqualToString:@"1"]) {
        
    } else {
        VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        videoDetailsVC.title = @"详情";
        
        videoDetailsVC.sceVideo = sceVideo;
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
