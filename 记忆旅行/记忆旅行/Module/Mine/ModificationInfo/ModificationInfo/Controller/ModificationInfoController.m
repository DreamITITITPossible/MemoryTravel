//
//  ModificationInfoController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ModificationInfoController.h"
#import "List_ImageTableViewCell.h"
#import "List_TextTableViewCell.h"
#import "DateTimePickerView.h"
#import "AreaViewController.h"
#import "SignatureViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKLocalSearchRequest.h>
@interface ModificationInfoController ()
<
UITableViewDataSource,
UITableViewDelegate,
MKMapViewDelegate,
MKLocalSearchCompleterDelegate,
AreaViewControllerDelegate,
SignatureViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DateTimePickerView *dateTimePickerView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *intro_albumArray;
@property (nonatomic, strong) NSMutableArray *sectionDetailsArray;
@property (nonatomic, strong) NSMutableArray *infoDetailsArray;
@property (nonatomic, strong) NSMutableArray *intro_albumDetailsArray;
@property (nonatomic, strong) UIImage *headIcon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, copy) NSString *baseUpdateURL;
@end

@implementation ModificationInfoController
- (void)getMemberListData {
    self.infoArray = [NSMutableArray arrayWithObject:@"头像"];
    
    self.intro_albumArray = [NSMutableArray arrayWithObjects:@"昵称", @"性别", @"地区", @"生日", @"个性签名", nil];
    
    
    
    self.sectionArray =[NSMutableArray arrayWithObjects:self.infoArray, self.intro_albumArray, nil];
    

    self.infoDetailsArray = [NSMutableArray array];
    [self.infoDetailsArray addObject:_userInfo.headImage];
    self.intro_albumDetailsArray = [NSMutableArray arrayWithObjects:_userInfo.Nickname, _userInfo.Sex, _userInfo.Address, _userInfo.Age, _userInfo.kidneyname,nil];
    self.sectionDetailsArray = [NSMutableArray arrayWithObjects:self.infoDetailsArray, self.intro_albumDetailsArray, nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"修改信息"];;
    self.userInfo = [UserInfo getUserDetailsInfomation];
    self.baseUpdateURL = @"http://www.yundao91.cn/ssh2/tour?cmd=update";

    [self getMemberListData];
    [self createTableView];
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.y = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(LINEBG);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        static  NSString *const list_ImageIdentifier = @"list_ImageIdentifier";
        List_ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:list_ImageIdentifier];
        if (nil == cell) {
            cell = [[List_ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:list_ImageIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.listTitle = self.sectionArray[indexPath.section][indexPath.row];
        cell.headIcon =  self.sectionDetailsArray[indexPath.section][indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        return cell;
    }
    
    
    static  NSString *const ID = @"memberCell";
    List_TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[List_TextTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.listTitle = self.sectionArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    cell.info = self.sectionDetailsArray[indexPath.section][indexPath.row];
    
    cell.selected = YES;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self showActionSheet];
    } else {
        switch (indexPath.row) {
            case 0:
                [self showNickNameAlertController];
                break;
            case 1:
                [self showSexAlertController];

                break;
            case 2:
                [self pushToAreaVC];
                break;
            case 3:
                [self showAgePickerView];
                break;
            case 4:
                [self pushtoSignatureVC];
                break;
            default:
                break;
        }
     
    }
}
- (void)updateDataWithBody:(NSString *)body Str:(NSString *)str Row:(NSInteger)row {
    
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    
        NSString *urlString =[NSString stringWithFormat:@"%@&%@", _baseUpdateURL , body];
        // Body
        HttpClient *httpClient = [[HttpClient alloc] init];
        [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
            NSDictionary *dic = result;
            
            NSNumber *flag = [dic objectForKey:@"flag"];
            NSString *msg = [dic objectForKey:@"result"];
            if ([flag isEqual:@1]) {
                switch (row) {
                    case 0:
                        [MBProgressHUD showTipMessageInView:@"修改昵称成功"];
                        _userInfo.Nickname =  str;
                        break;
                    case 1:
                        [MBProgressHUD showTipMessageInView:@"修改性别成功"];

                        _userInfo.Sex =  str;
                        break;
                    case 2:
                        [MBProgressHUD showTipMessageInView:@"修改地区成功"];
                        _userInfo.Address =  str;
                        break;
                    case 3:
                        [MBProgressHUD showTipMessageInView:@"修改生日成功"];
                        _userInfo.Age =  str;
                        break;
                    case 4:
                        [MBProgressHUD showTipMessageInView:@"修改签名成功"];
                        _userInfo.kidneyname =  str;
                        break;
                    default:
                        break;
                }
                [self.intro_albumDetailsArray replaceObjectAtIndex:row withObject:str];
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
                
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
                NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
                [userinfoDefaults setObject:userInfoData forKey:@"userInfoData"];
                [userinfoDefaults synchronize];

                
            } else {
                [MBProgressHUD showTipMessageInView:msg];
            }
        } failure:^(NSError *error) {
         
        }];
    
}
#pragma mark - 修改昵称
- (void)showNickNameAlertController {
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *nickNameAlertController = [UIAlertController alertControllerWithTitle:@"填写昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [nickNameAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = @"昵称不可重复且为4-12位字符";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
            
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
            // Body
            NSString *bodyStr = [NSString stringWithFormat:@"cmd=isnameuse&nickname=%@", [nickNameAlertController.textFields.firstObject.text urlEncode]];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
                
                NSDictionary *dic = result;
                
                NSNumber *flag = [dic objectForKey:@"flag"];
                NSString *msg = [dic objectForKey:@"result"];
                if ([flag isEqual:@1]) {
                   
                    [self updateDataWithBody:[NSString stringWithFormat:@"Nickname=%@", [dic objectForKey:@"name"]] Str:[dic objectForKey:@"name"] Row:0];
                    

                } else {
                    [MBProgressHUD showTipMessageInWindow:msg];
                    [self showNickNameAlertController];
                    
                }
                
            } failure:^(NSError *error) {
                
                
            }];
        }];
        [nickNameAlertController addAction:cancleAction];
        [nickNameAlertController addAction:sureAction];
        sureAction.enabled = NO;
        [self presentViewController:nickNameAlertController animated:true completion:nil];
    }
}
// 文本框输入监听
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        UIAlertAction *sureAction = alertController.actions.lastObject;
        sureAction.enabled = nameTextField.text.length >= 4 && nameTextField.text.length <= 12;
    }
}
#pragma mark - 修改性别
- (void)showSexAlertController {
    UIAlertController *nickNameAlertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sex = @"男";
        [self updateDataWithBody:[NSString stringWithFormat:@"Sex=%@", _sex ] Str:_sex Row:1];
    
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sex = @"女";
        [self updateDataWithBody:[NSString stringWithFormat:@"Sex=%@", _sex] Str:_sex Row:1];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [nickNameAlertController addAction:maleAction];
    [nickNameAlertController addAction:femaleAction];
    [nickNameAlertController addAction:cancleAction];
    [self presentViewController:nickNameAlertController animated:true completion:nil];
    
}
#pragma mark - 修改地区
- (void)pushToAreaVC {
    AreaViewController *areaVC = [[AreaViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    areaVC.delegate = self;
    areaVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"地区"];;
    [self.navigationController pushViewController:areaVC animated:YES];
}
- (void)getAddress:(NSString *)address {
      [self updateDataWithBody:[NSString stringWithFormat:@"Address=%@", address] Str:address Row:2];
}
#pragma mark - 修改签名
- (void)pushtoSignatureVC {
    SignatureViewController *signatureVC = [[SignatureViewController alloc] init];
    signatureVC.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"修改签名"];;
    self.hidesBottomBarWhenPushed = YES;
    signatureVC.delegate = self;
    signatureVC.signature = _userInfo.kidneyname;
    [self.navigationController pushViewController:signatureVC animated:YES];
}
- (void)getSignature:(NSString *)signature {
    [self updateDataWithBody:[NSString stringWithFormat:@"kidneyname=%@", signature] Str:signature Row:4];
}
#pragma mark - 修改年龄
- (void)showAgePickerView {
    typeof(self) __weak weakself = self;
    self.dateTimePickerView = [[DateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    [_dateTimePickerView setMinYear:1900];
    NSDate *yearNow = [NSDate date];
    [_dateTimePickerView setMaxYear:[yearNow year]];
    _dateTimePickerView.title = @"出生日期";
    _dateTimePickerView.titleColor = [UIColor yellowColor];
    
    _dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        [weakself updateDataWithBody:[NSString stringWithFormat:@"Age=%@", datetimeStr] Str:datetimeStr Row:3];
    };
    if (_dateTimePickerView) {
        [self.view addSubview:_dateTimePickerView];
        [_dateTimePickerView showHcdDateTimePicker];
    }
    
}
#pragma mark - 修改头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    
    //获得编辑后的图片
    UIImage *editedImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
    CGFloat height = editedImage.size.height;
    CGFloat width = editedImage.size.width;
    
    editedImage = [editedImage scaleToSize:editedImage size:CGSizeMake(200, 200 * height / width)];
    editedImage = [editedImage imageByScalingProportionallyToSize:CGSizeMake(200, 200 * height / width)];
    
    NSString *urlStr = _baseUpdateURL;
    //网络请求管理器
    User *user = [User getUserInfo];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //JSON
    //申明返回的结果类型
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据类型
    sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID] forHTTPHeaderField:@"Cookie"];
    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID], @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary]};
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(editedImage);
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        NSLog(@"%@", [responseObject objectForKey:@"result"]);
        NSDictionary *dic = responseObject;
        NSNumber *flag = [dic objectForKey:@"flag"];
        if ([flag isEqual:@1]) {
            _userInfo.Photo = [dic objectForKey:@"userheadurl"];
            UIImage *image = [UIImage getImageFromURL:[NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/%@", [dic objectForKey:@"userheadurl"]]];
            self.userInfo.headImage = image;
            NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
            NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
            [userinfoDefaults setObject:userInfoData forKey:@"userInfoData"];
            [userinfoDefaults synchronize];
            [self.infoDetailsArray  replaceObjectAtIndex:0 withObject:editedImage];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            self.headIcon = editedImage;
            [MBProgressHUD showTipMessageInWindow:[dic objectForKey:@"result"]];

        } else {
            [MBProgressHUD showTipMessageInWindow:[dic objectForKey:@"result"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
    }];
    
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
