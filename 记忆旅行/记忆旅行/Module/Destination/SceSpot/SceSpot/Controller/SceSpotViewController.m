//
//  SceSpotViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceSpotViewController.h"
#import "SceSpotCollectionViewCell.h"
#import "SceSpotDetailsViewController.h"
static NSString *const cellIdentifier = @"SceCollectionCell";

@interface SceSpotViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, strong) NSMutableArray *sceSpotArr;
@end

@implementation SceSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self getSceSpotData];
    [self createCollectionView];

}

- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    self.lon = array.firstObject;
    self.lat = array.lastObject;
    
}
- (void)getSceSpotData {
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=getSceMapInfor&lon=%@&lat=%@", _lon, _lat];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        self.sceSpotArr = [NSMutableArray array];
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                SceSpotModel *sceSpot = [SceSpotModel mj_objectWithKeyValues:dic];
                [_sceSpotArr addObject:sceSpot];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView.mj_header endRefreshing];
                
                
                [_collectionView reloadData];
                
            });
            
        }
        
        
    } readCachesIfFailed:^(id responseObject) {
        self.sceSpotArr = [NSMutableArray array];
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                SceSpotModel *sceSpot = [SceSpotModel mj_objectWithKeyValues:dic];
                [_sceSpotArr addObject:sceSpot];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView.mj_header endRefreshing];
                
                
                [_collectionView reloadData];
                
            });
            
        }
 
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        self.sceSpotArr = [NSMutableArray array];
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                SceSpotModel *sceSpot = [SceSpotModel mj_objectWithKeyValues:dic];
//                [_sceSpotArr addObject:sceSpot];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                    [self.collectionView.mj_header endRefreshing];
//                
//                
//                [_collectionView reloadData];
//                
//            });
//
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // item的尺寸 (cell大小)
    //    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 15, 150);
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(240, 240, 240, 1), [UIColor blackColor]);
    [self.view addSubview:_collectionView];
    // 只能使用注册的方式
    [_collectionView registerClass:[SceSpotCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.alwaysBounceVertical = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getSceSpotData];
    }];
    

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_sceSpotArr.count != 0) {
        return _sceSpotArr.count;
    }
    return 0;

}
// 设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从重用池取cell
    SceSpotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.sceSpot = _sceSpotArr[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SceSpotDetailsViewController *detailsVC = [[SceSpotDetailsViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    SceSpotModel *sceSpot = _sceSpotArr[indexPath.item];
    detailsVC.title = sceSpot.SceName;
    detailsVC.urlStr = sceSpot.sceInforUrl;
    [self.navigationController pushViewController:detailsVC animated:YES];
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
