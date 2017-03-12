//
//  ScePhotoViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ScePhotoViewController.h"
#import "ScePhotoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ScePhotoLayout.h"
#import "ScePhotoModel.h"
#import "AlbumViewController.h"
#import "SortDownListViewController.h"

static NSString *const cellIdentifier = @"ScePhotoCell";

@interface ScePhotoViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
ScePhotoLayoutDelegate,
SortDownListViewControllerDelegate
>
@property (nonatomic, strong) NSMutableArray *heightArr;
@property (nonatomic, strong) NSMutableArray *widthArr;
@property (nonatomic, retain) NSMutableArray *shortImgURLArray;
@property (nonatomic, strong) NSMutableArray *scePhotoArr;
@property (nonatomic, strong) NSMutableArray *bigImageUrlArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger picType;
@property (nonatomic, assign) NSInteger isOfficial;
@property (nonatomic, assign) NSInteger page;
// 标记上下的刷新
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation ScePhotoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortVC.sortArray = @[@"全部", @"热门", @"最新", @"官方"];
    _type = 1;
    _picType = 0;
    _isOfficial = 0;
    _page = 1;
    self.heightArr = [NSMutableArray array];
    self.widthArr = [NSMutableArray array];
    self.scePhotoArr = [NSMutableArray array];
    self.shortImgURLArray = [NSMutableArray array];
    self.bigImageUrlArray = [NSMutableArray array];
   
    [self getScePhotoData];
    [self createCollectionView];
    // Do any additional setup after loading the view, typically from a nib.
    
}
#pragma mark - 排序

- (void)getSortInfomationWithSortNum:(NSInteger)sortNum {
    switch (sortNum) {
        case 0:
            _type = 1;
            _picType = 0;
            _isOfficial = 0;
            break;
        case 1:
            _type = 1;
            _picType = 2;
            _isOfficial = 0;
            break;
        case 2:
            _type = 2;
            _picType = 2;
            _isOfficial = 0;
            break;
        case 3:
            _type = 1;
            _picType = 1;
            _isOfficial = 2;
            break;
        default:
            break;
    
    }
    _page = 1;
    [NSThread sleepForTimeInterval:0.2];
    [self.collectionView.mj_header beginRefreshing];
    _isUpState = NO;
    [self getScePhotoData];
    
    
  
}

- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    self.lon = array.firstObject;
    self.lat = array.lastObject;
    
}
- (void)getScePhotoData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/scePic?&type=%ld&size=20&lon=%@&cmd=getPictureVoByloat&lat=%@&picType=%ld&isOfficial=%ld&page=%ld",_type, _lon, _lat, _picType, _isOfficial, _page];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_scePhotoArr removeAllObjects];
            [_heightArr removeAllObjects];
            [_bigImageUrlArray removeAllObjects];
            [_shortImgURLArray removeAllObjects];
            [_widthArr removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                ScePhotoModel *scePhoto = [ScePhotoModel mj_objectWithKeyValues:dic];
                [_scePhotoArr addObject:scePhoto];
                [_shortImgURLArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picShortPath]];
                [_bigImageUrlArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picPath]];
                [_heightArr addObject:scePhoto.picHeight];
                [_widthArr addObject:scePhoto.picWidth];
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                
                [self.collectionView.mj_header endRefreshing];
                _collectionView.mj_footer.state = MJRefreshStateIdle;
            } else {
                [self.collectionView.mj_footer endRefreshing];
                
                if (_scePhotoArr.count % 20 != 0 || _scePhotoArr.count == 0) {
                    
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
            }
            
            [_collectionView reloadData];
            
        });

    } readCachesIfFailed:^(id responseObject) {
        if (_isUpState == NO) {
            // 如果下拉就清空所有数据
            [_scePhotoArr removeAllObjects];
            [_heightArr removeAllObjects];
            [_bigImageUrlArray removeAllObjects];
            [_shortImgURLArray removeAllObjects];
            [_widthArr removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            NSArray *array = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                ScePhotoModel *scePhoto = [ScePhotoModel mj_objectWithKeyValues:dic];
                [_scePhotoArr addObject:scePhoto];
                [_shortImgURLArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picShortPath]];
                [_bigImageUrlArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picPath]];
                [_heightArr addObject:scePhoto.picHeight];
                [_widthArr addObject:scePhoto.picWidth];
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isUpState == NO) {
                
                [self.collectionView.mj_header endRefreshing];
                _collectionView.mj_footer.state = MJRefreshStateIdle;
            } else {
                [self.collectionView.mj_footer endRefreshing];
                
                if (_scePhotoArr.count % 20 != 0 || _scePhotoArr.count == 0) {
                    
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
            }
            
            [_collectionView reloadData];
            
        });

    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        
//        if (_isUpState == NO) {
//            // 如果下拉就清空所有数据
//            [_scePhotoArr removeAllObjects];
//            [_heightArr removeAllObjects];
//            [_bigImageUrlArray removeAllObjects];
//            [_shortImgURLArray removeAllObjects];
//            [_widthArr removeAllObjects];
//        }
//        
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            NSArray *array = [result objectForKey:@"result"];
//            for (NSDictionary *dic in array) {
//                ScePhotoModel *scePhoto = [ScePhotoModel mj_objectWithKeyValues:dic];
//                [_scePhotoArr addObject:scePhoto];
//                [_shortImgURLArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picShortPath]];
//                [_bigImageUrlArray addObject:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", scePhoto.picPath]];
//                [_heightArr addObject:scePhoto.picHeight];
//                [_widthArr addObject:scePhoto.picWidth];
//                
//            }
//           
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_isUpState == NO) {
//                
//                [self.collectionView.mj_header endRefreshing];
//                _collectionView.mj_footer.state = MJRefreshStateIdle;
//            } else {
//                [self.collectionView.mj_footer endRefreshing];
//                
//                if (_scePhotoArr.count % 20 != 0 || _scePhotoArr.count == 0) {
//                    
//                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//
//            }
//            
//            [_collectionView reloadData];
//            
//        });
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)createCollectionView{
    ScePhotoLayout *flowLayout = [[ScePhotoLayout alloc] init];
    // 设置列数
    flowLayout.numberOfColumn = 2;
    // 设置间距
    flowLayout.itemMergin = 5.f;
    
    flowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ScePhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
    //下拉刷新

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        _isUpState = NO;
        [self getScePhotoData];
    }];
    
    
    
    //上拉加载
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        self.page = _page + 1;
        [self getScePhotoData];
    }];
    

    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _scePhotoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.scePhoto = _scePhotoArr[indexPath.item];
//    cell.image = _imageArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    AlbumViewController *albumVC = [[AlbumViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    albumVC.currentIndex = indexPath.item;
    albumVC.name = _sceName;
    albumVC.albumArray = _bigImageUrlArray;
    [self.navigationController pushViewController:albumVC animated:YES];
    
}
// 返回每一个item的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UIImage *image = _imageArray[indexPath.item];
//    CGRect boundingRect = {0, 0, 120, CGFLOAT_MAX};
//    // AVFoundation框架下提供媒体图片资源自适应高度的函数
//    CGRect contentRect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
//    return contentRect.size;
//}
// 实现协议方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ScePhotoLayout *)layout width:(CGFloat)width heightAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIImage *image = _shortImageArray[indexPath.item];
//    CGRect boundingRect = {0, 0, width, CGFLOAT_MAX};
    // AVFoundation框架下提供媒体图片资源自适应高度的函数
//    CGRect contentRect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
    CGFloat imageHeight;
    imageHeight = [_heightArr[indexPath.item] floatValue];
    CGFloat imageWidth;
    imageWidth = [_widthArr[indexPath.item] floatValue];
    CGFloat scale;
    if (imageWidth == 0 || imageHeight == 0) {
        scale = 1;
    } else {
        scale = imageHeight / imageWidth;
    }
    CGFloat height = width * scale;
    return height;
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
