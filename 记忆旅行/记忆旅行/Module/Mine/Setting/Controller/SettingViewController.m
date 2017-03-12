//
//  SettingViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SettingViewController.h"
#import "ResetPWDViewController.h"
@interface SettingViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *listArray;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *thirdArray;
@property (nonatomic, assign) CGFloat totalMBytes;
@end

@implementation SettingViewController
- (void)viewWillDisappear:(BOOL)animated {
    //    self.navigationController.navigationBarHidden = YES;
}
- (void)createTableView {
    User *user = [User getUserInfo];
    CGFloat tableViewHeight;
    if (user.isLogin) {
        tableViewHeight = self.view.frame.size.height - 114;
    } else {
        tableViewHeight = self.view.frame.size.height - 64;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    [self.view addSubview:_tableView];
    //    _tableView.y = -20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
}
- (void)dataList{
    self.firstArray = @[@"账号绑定", @"修改密码"];
    self.secondArray = @[@"夜间模式", @"清空缓存",@"检查更新"];
    
    self.thirdArray = @[@"关于我们"];
    self.listArray = @[_firstArray, _secondArray, _thirdArray];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    //    self.tabBarController.tabBar.hidden = YES;
   User *user = [User getUserInfo];
    if (user.isLogin) {
        
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:quitButton];
    [quitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
//    quitButton.backgroundColor = JYXColor(64, 224, 208, 1);
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.equalTo(@50);
    }];
    
    [quitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userData"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:destructiveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
    }
    [self dataList];
    [self createTableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_listArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"mineSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
//    cell.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434);
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
//    cell.accessoryView.subviews.lastObject.dk_tintColorPicker = DKColorPickerWithColors([UIColor grayColor], [UIColor whiteColor]);

    if (indexPath.section == 1 && indexPath.row == 0) {
        UISwitch *nightModeSwitch = [[UISwitch alloc] init];
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
            nightModeSwitch.on = YES;
        } else {
            nightModeSwitch.on = NO;
        }
        [nightModeSwitch addTarget:self action:@selector(nightModeSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = nightModeSwitch;

    } else if (indexPath.section == 1 && indexPath.row == 1) {
        CGFloat MBytes = [JYXCache getAllCacheSize] / 1024.0 / 1024.0;
        SDImageCache *cache = [SDImageCache sharedImageCache];
        NSLog(@"text-----%llu", [JYXCache getAllCacheSize]);
        NSLog(@"image-----%lu", (unsigned long)[cache getSize]);
        CGFloat cacheSize = cache.getSize / 1024.0 / 1024.0;
        self.totalMBytes = MBytes + cacheSize;
        CGFloat width = [UILabel getWidthWithTitle:[NSString stringWithFormat:@"%.2fM", _totalMBytes] font:kFONT_SIZE_15_BOLD];
        UILabel *bytesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        bytesLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        bytesLabel.font = kFONT_SIZE_15_BOLD;
        bytesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor grayColor], [UIColor darkGrayColor]);
        bytesLabel.text = [NSString stringWithFormat:@"%.2fM", _totalMBytes];
        cell.accessoryView = bytesLabel;

        
    }
    
    
    
    
    return cell;
}
- (void)nightModeSwitch:(UISwitch *)switchView {
    if (switchView.on) {
        [self.dk_manager nightFalling];
    } else {
        [self.dk_manager dawnComing];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        if (indexPath.row == 1) {
            ResetPWDViewController *resetPWDVC = [[ResetPWDViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resetPWDVC animated:YES];
        }
        } else {
            [self showAlertActionLogin];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前缓存大小为%.2fMB, 确定清空?", _totalMBytes] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [JYXCache removeAllCache];
                [[SDImageCache sharedImageCache] clearDisk];;
                
                UIAlertController *alertOK = [UIAlertController alertControllerWithTitle:@"缓存已清空" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alertOK addAction:OKAction];
                
                [self presentViewController:alertOK animated:YES completion:nil];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                CGFloat MBytes = [JYXCache getAllCacheSize] / 1024.0 / 1024.0;
                SDImageCache *cache = [SDImageCache sharedImageCache];
                CGFloat cacheSize = cache.getSize / 1024.0 / 1024.0;
                
                CGFloat width = [UILabel getWidthWithTitle:[NSString stringWithFormat:@"%.2fM", MBytes + cacheSize] font:kFONT_SIZE_15_BOLD];
                UILabel *bytesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
                bytesLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
                bytesLabel.font = kFONT_SIZE_15_BOLD;
                bytesLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor grayColor], [UIColor darkGrayColor]);
                bytesLabel.text = [NSString stringWithFormat:@"%.2fM", MBytes + cacheSize];
                cell.accessoryView = bytesLabel;
                
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:cancelAction];
            [alert addAction:destructiveAction];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
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
