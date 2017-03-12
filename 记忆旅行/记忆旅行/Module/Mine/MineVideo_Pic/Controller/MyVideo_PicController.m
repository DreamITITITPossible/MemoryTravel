//
//  MyVideo_PicController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "MyVideo_PicController.h"
#import "VO.h"
#import "PersonalList.h"
#import "SceVideoModel.h"
#import "MyVideo_PicCell.h"
#import "VideoDetailsViewController.h"
static NSString *const cellIdentifier = @"myCellID";
@interface MyVideo_PicController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *myVideo_picArr;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation MyVideo_PicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.myVideo_picArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    if ([_videoOrPic isEqualToString:@"video"]) {
        [self getMyVideoData:YES];
        
    } else {
        [self getMyPicData:YES];
        
    }
    [self createCollectionView];
    
}
- (void)getMyPicData:(BOOL)showHub {
    
    User *user = [User getUserInfo];
    UserInfo *userinfo = [UserInfo getUserDetailsInfomation];
    //    _logState = user.isLogin;
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&browseUserID=%@&cmd=queryOneselTracePic&page=%ld&size=20&tel=%@", userinfo.TourID, _page, userinfo.TEL];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_myVideo_picArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *arr = [VO mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_myVideo_picArr addObjectsFromArray:arr];
        }  dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_collectionView reloadData];
        });

        
    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_myVideo_picArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *arr = [VO mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_myVideo_picArr addObjectsFromArray:arr];
        }  dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_collectionView reloadData];
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:showHub success:^(id result) {
//        if (_isUpState == NO) {
//            // 如果下拉就清空所有数据
//            [_myVideo_picArr removeAllObjects];
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *arr = [VO mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
//            [_myVideo_picArr addObjectsFromArray:arr];
//        }  dispatch_async(dispatch_get_main_queue(), ^{
//            if (_isUpState == NO) {
//                _collectionView.mj_footer.state = MJRefreshStateIdle;
//                [self.collectionView.mj_header endRefreshing];
//            } else {
//                [self.collectionView.mj_footer endRefreshing];
//                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
//                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//            }
//            
//            [_collectionView reloadData];
//        });
//    } failure:^(NSError *error) {
//        
//        
//    }];

}
- (void)getMyVideoData:(BOOL)showHub {
    
    User *user = [User getUserInfo];
//    _logState = user.isLogin;
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&size=20&videoType=4&cmd=queryOneselfVideo&type=2&page=%ld", _page];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_myVideo_picArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *arr = [SceVideoModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_myVideo_picArr addObjectsFromArray:arr];
        }  dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_collectionView reloadData];
        });

        
    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_myVideo_picArr removeAllObjects];
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *arr = [SceVideoModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_myVideo_picArr addObjectsFromArray:arr];
        }  dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [_collectionView reloadData];
        });
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:showHub success:^(id result) {
//        if (_isUpState == NO) {
//            // 如果下拉就清空所有数据
//            [_myVideo_picArr removeAllObjects];
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *arr = [SceVideoModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
//            [_myVideo_picArr addObjectsFromArray:arr];
//        }  dispatch_async(dispatch_get_main_queue(), ^{
//            if (_isUpState == NO) {
//                _collectionView.mj_footer.state = MJRefreshStateIdle;
//                [self.collectionView.mj_header endRefreshing];
//            } else {
//                [self.collectionView.mj_footer endRefreshing];
//                if (_myVideo_picArr.count % 20 != 0 || _myVideo_picArr.count == 0) {
//                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//            }
//            
//            [_collectionView reloadData];
//        });
//    } failure:^(NSError *error) {
//        
//        
//    }];

}
- (void)createCollectionView {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // item的尺寸 (cell大小)
        //    flowLayout.itemSize = self.view.bounds.size;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 20, 130);
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
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        
        
        
        // 创建集合视图
        // 需要提供一个布局对象
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
    _collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    [self.view addSubview:_collectionView];
        // 只能使用注册的方式
        [_collectionView registerClass:[MyVideo_PicCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        if ([_videoOrPic isEqualToString:@"video"]) {
            [self getMyVideoData:NO];
            
        } else {
            [self getMyPicData:NO];
            
        }

    }];
    
    //上拉加载
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        if ([_videoOrPic isEqualToString:@"video"]) {
            [self getMyVideoData:NO];
            
        } else {
            [self getMyPicData:NO];
            
        }

    }];
    
    
}



// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _myVideo_picArr.count;
    
}
// 设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从重用池取cell
    MyVideo_PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([_videoOrPic isEqualToString:@"video"]) {
        cell.sceVideo = _myVideo_picArr[indexPath.item];
    } else {
        PersonalList *personalList = [[PersonalList alloc] init];
        personalList.vo = _myVideo_picArr[indexPath.item];
        personalList.type = personalList.vo.type;
        cell.personalList = personalList;
        
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
    if ([_videoOrPic isEqualToString:@"video"]) {
        videoDetailsVC.sceVideo = _myVideo_picArr[indexPath.item];
    } else {
        PersonalList *personalList = [[PersonalList alloc] init];
        personalList.vo = _myVideo_picArr[indexPath.item];
        personalList.type = personalList.vo.type;
        videoDetailsVC.personalList = personalList;
        

    }

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDetailsVC animated:YES];
    
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
