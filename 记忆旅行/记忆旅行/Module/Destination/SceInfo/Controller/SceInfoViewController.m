//
//  SceInfoViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceInfoViewController.h"
#import "SceInfoModel.h"
#import "SceHeaderView.h"
#import "SceBtnCell.h"
#import "SceBtnView.h"
#import "SceSpotViewController.h"
#import "SceVideoViewController.h"
#import "ScePhotoViewController.h"
#import "SceNoteViewController.h"
@interface SceInfoViewController ()
<
SceBtnCellDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) SceHeaderView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SceInfoModel *sceInfo;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation SceInfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem getBarButtonItemWithImageName:@"icon_nav_share" HighLightedImageName:@"icon_nav_share" Size:CGSizeMake(21, 21) targetBlock:^{
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
            
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                UMSocialMessageObject *messageObject =   [UMSocialMessageObject messageObject];
                messageObject.title = @"Test";
                messageObject.text = [NSString stringWithFormat:@"我发现了一个好玩的地方\"%@\"，快来看看❗️", _sceInfo.SceName];
                UMShareWebpageObject *webpageObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"记忆旅行 | %@", _sceInfo.SceName] descr:_sceInfo.Nickname thumImage:[UIImage getImageFromURL:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _sceInfo.logoUrl]]];
                    webpageObject.webpageUrl = [NSString stringWithFormat:@"http://www.51laiya.com/manager/app.php?lon=%@&lat=%@&c=index&a=sceinfo&m=app", _lon, _lat];
                    
                             messageObject.shareObject = webpageObject;
                
                
                // 根据获取的platformType确定所选平台进行下一步操作
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                    NSLog(@"%@", result);
                    
                    NSLog(@"%@", error);
                    
                }];
            }];
        } else {
            [self showAlertActionLogin];
        }
        

        
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.cellHeight = 800;
    [self clickAllSceTermini];
    [self querySignContract];
    [self getHeaderData];
    
    [self createTableView];
    [self createHeaderView];
    
    
  
}

- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    self.lon = array.firstObject;
    self.lat = array.lastObject;
 
}
- (void)querySignContract {
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/operation?&cmd=querySignContract&lon=%@&lat=%@", _lon, _lat];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
          
            }
        
    } failure:^(NSError *error) {
        
    }];
    

}
- (void)clickAllSceTermini {
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/operation?&cmd=clickAllSceTermini&id=%@", _scenicSpots.ID];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)getHeaderData {
    
    NSString *urlStr =[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&Latitude=%@&Longitude=%@&cmd=getSceInfor", _lat, _lon];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.sceInfo = [SceInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            _headView.sceInfo = _sceInfo;
        }
        self.navigationItem.titleView = [UILabel getTitleViewWithTitle:_sceInfo.SceName];
        _tableView.tableHeaderView = _headView;
        
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.sceInfo = [SceInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            _headView.sceInfo = _sceInfo;
        }
        self.navigationItem.titleView = [UILabel getTitleViewWithTitle:_sceInfo.SceName];
        _tableView.tableHeaderView = _headView;
 
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.sceInfo = [SceInfoModel mj_objectWithKeyValues:[result objectForKey:@"result"]];
//            _headView.sceInfo = _sceInfo;
//        }
//        self.navigationItem.titleView = [UILabel getTitleViewWithTitle:_sceInfo.SceName];
//        _tableView.tableHeaderView = _headView;
//    } failure:^(NSError *error) {
//        
//    }];
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //    _tableView.y = -20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.bounces = NO;
    _tableView.tableHeaderView.height = 250;
    [self.view addSubview:_tableView];

    
    
}
- (void)createHeaderView {
    self.headView = [[SceHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    //    _headView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    _headView.clipsToBounds = YES;
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    _headView.clipsToBounds = YES;
    _headView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _tableView.tableHeaderView = _headView;
    _tableView.tableHeaderView.height = 250;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const ID = @"sceBtnCell";
    SceBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SceBtnCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.tag = indexPath.row;
    cell.height = _cellHeight;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.scenicSpots = _scenicSpots;
    return cell;
}
- (void)getWebViewHeight:(CGFloat)height {
    _cellHeight = height + 90;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}
- (void)clickWithIndex:(NSInteger)index {
    if (0 == index) {
        SceSpotViewController *sceSpotVC = [[SceSpotViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        sceSpotVC.scenicSpots = _scenicSpots;
        sceSpotVC.title = @"相关景点";
        [self.navigationController pushViewController:sceSpotVC animated:YES];
    } else if (1 == index) {
        SceVideoViewController *sceVideoVC = [[SceVideoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        sceVideoVC.scenicSpots = _scenicSpots;
        sceVideoVC.title = @"视频";
        [self.navigationController pushViewController:sceVideoVC animated:YES];
    } else if (2 == index) {
        ScePhotoViewController *scePhotoVC = [[ScePhotoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        scePhotoVC.scenicSpots = _scenicSpots;
        scePhotoVC.sceName = _sceInfo.SceName;
        scePhotoVC.title = @"美图";
        [self.navigationController pushViewController:scePhotoVC animated:YES];
    } else {
        SceNoteViewController *sceNoteVC = [[SceNoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        sceNoteVC.scenicSpots = _scenicSpots;
        sceNoteVC.title = @"相关游记";
        [self.navigationController pushViewController:sceNoteVC animated:YES];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
      CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
    
    
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
