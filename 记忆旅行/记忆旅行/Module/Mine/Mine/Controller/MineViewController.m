//
//  MineViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "MineViewController.h"
#import "PersonalInfo.h"
#import "MineHeaderView.h"
#import "MineCellModel.h"
#import "Attention_FansViewController.h"
#import "PersonalHomepageViewController.h"
#import "ModificationInfoController.h"
#import "SettingViewController.h"
#import "MyVideo_PicController.h"
#import "MyCollectionController.h"
@interface MineViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MineHeaderViewDelegate
>
@property (nonatomic, strong) PersonalInfo *personalInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineHeaderView *headView;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) NSArray *mineArr;
@property (nonatomic, strong) NSArray *settingArr;
@property (nonatomic, assign) BOOL logState;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    User *user = [User getUserInfo];
    if (user.isLogin == YES && user.isLogin != _logState) {
        _headView.height = 154;
        _tableView.tableHeaderView = _headView;
        [self getPersonalInfo];
        _logState = user.isLogin;
    } else if (user.isLogin == NO && user.isLogin != _logState){
        _headView.height = 100;
        _headView.isLogin = NO;
        _logState = user.isLogin;
        _tableView.tableHeaderView = _headView;

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    User *user = [User getUserInfo];
    _logState = user.isLogin;
    self.mineArr = @[@[@"mine_video", @"我的视频"], @[@"mine_pic", @"我的旅图"], @[@"mine_location", @"我的旅迹"], @[@"mine_collect", @"我的收藏"]];
    self.settingArr = @[@[@"mine_complain", @"吐槽"], @[@"mine_setting", @"设置"]];
    self.sectionArr = @[_mineArr ,_settingArr];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"我的"];;
    if (_logState) {
        [self getPersonalInfo];
    }
    [self createTableView];
    [self setupHeaderView];
    
}


- (void)getPersonalInfo {
    User *user = [User getUserInfo];
    _logState = user.isLogin;
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [NSString stringWithFormat:@"%@/ssh2/tour?&cmd=queryPersonalInfor&tel=%@", baseURL, userInfo.TEL];
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            _headView.isLogin = YES;
            _headView.personalInfo = _personalInfo;
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            _headView.isLogin = YES;
            _headView.personalInfo = _personalInfo;
        }
 
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.personalInfo = [PersonalInfo mj_objectWithKeyValues:[result objectForKey:@"result"]];
//            _headView.isLogin = YES;
//            _headView.personalInfo = _personalInfo;
//        }
//    } failure:^(NSError *error) {
//        
//        
//    }];
    
}




- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //    _tableView.y = -20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.bounces = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
   
    
    
}

- (void)setupHeaderView
{
    User * user = [User getUserInfo];
    CGFloat height;
    if (user.isLogin) {
        height = 154;
    } else {
        height = 100;
    }
    
    self.headView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    _headView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _headView.delegate = self;
    _headView.clipsToBounds = YES;
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    _headView.clipsToBounds = YES;
    _tableView.tableHeaderView = _headView;
    
    // 与图像高度一样防止数据被遮挡
    _tableView.tableHeaderView.frame = _headView.frame;

    //        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , _waveImageView.height)];
    
}
#pragma mark - 点击关注或粉丝事先协议
- (void)ClickFans_AttentionBtnPushToVCWithType:(NSString *)type TouristID:(NSString *)touristID {
    self.hidesBottomBarWhenPushed = YES;
    Attention_FansViewController *attention_FansVC = [[Attention_FansViewController alloc] init];
    attention_FansVC.type = type;
    attention_FansVC.touristID = touristID;
    if ([type isEqualToString:@"1"]) {
        attention_FansVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"Ta的关注"];;
    } else {
        attention_FansVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"Ta的粉丝"];;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attention_FansVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 跳转到个人信息
- (void)clickMemberViewPushToPersonalHomePageWithPersonalInfo:(PersonalInfo *)personalInfo {
    User *user = [User getUserInfo];
    if (user.isLogin) {
        
    PersonalHomepageViewController *personalVC = [[PersonalHomepageViewController alloc] init];
        personalVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"个人主页"];;

    personalVC.touristID = personalInfo.TouristID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    } else {
        [self presentToLoginVC];
    }
}
#pragma mark - 跳转到修改个人信息
- (void)clickHeadImageViewPushToModificationInfo {
    User *user = [User getUserInfo];
    if (user.isLogin) {
    ModificationInfoController *modificationInfoVC = [[ModificationInfoController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
        
        modificationInfoVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"修改资料"];;
    [self.navigationController pushViewController:modificationInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    } else {
        [self presentToLoginVC];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_sectionArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *const ID = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSArray *arr = _sectionArr[indexPath.section];
   cell.imageView.dk_imagePicker = DKImagePickerWithNames([arr[indexPath.row] firstObject], [arr[indexPath.row] firstObject]);
//   cell.imageView.dk_alphaPicker = DKAlphaPickerWithAlphas(1.f, 0.5f, 0.1f);

//    cell.imageView.image = [UIImage imageNamed: [arr[indexPath.row] firstObject]];
    cell.textLabel.text = [arr[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        switch (indexPath.row) {
            case 0:
                [self pushToMyVideo_PicWithType:indexPath.row];
                
                break;
            case 1:
                [self pushToMyVideo_PicWithType:indexPath.row];
                
                break;
            case 3:
                [self pushToMyCollections];
                
                break;

            default:
                break;
        }
        } else {
            [self showAlertActionLogin];
        }
    } else {
        switch (indexPath.row) {
            case 0:
                break;
                
            default:
                [self pushToSettingVC];
                break;
        }
    }
}
- (void)pushToMyVideo_PicWithType:(NSInteger)type {
    MyVideo_PicController *myVideo_PicVC = [[MyVideo_PicController alloc] init];
    if (type == 0) {
        
        myVideo_PicVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"我的视频"];;
        myVideo_PicVC.videoOrPic = @"video";
    } else {
        myVideo_PicVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"我的旅图"];;
        myVideo_PicVC.videoOrPic = @"pic";

    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myVideo_PicVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)pushToMyCollections {
    MyCollectionController *myCollectionVC = [[MyCollectionController alloc] init];
      self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCollectionVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)pushToSettingVC {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"设置"];;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
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
