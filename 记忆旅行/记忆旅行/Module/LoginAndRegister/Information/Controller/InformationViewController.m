//
//  InformationViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "InformationViewController.h"
#import "List_ImageTableViewCell.h"
#import "List_TextTableViewCell.h"
#import "DateTimePickerView.h"
#import "LoginViewController.h"
@interface InformationViewController ()
<
UITableViewDataSource,
UITableViewDelegate
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
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, assign) BOOL firstChecked;
@property (nonatomic, assign) BOOL isChecked;
@end

@implementation InformationViewController
- (void)getMemberListData {
    self.infoArray = [NSMutableArray arrayWithObject:@"头像"];
    
    self.intro_albumArray = [NSMutableArray arrayWithObjects:@"昵称", @"性别", @"年龄", nil];
    
    
    
    self.sectionArray =[NSMutableArray arrayWithObjects:self.infoArray, self.intro_albumArray, nil];
    if (_headImgURL) {
        self.headIcon =  [UIImage getImageFromURL:_headImgURL];
    } else {
    UIImage *defaultHeadIcon = [UIImage imageNamed:@"default_headImage"];
    self.headIcon = [defaultHeadIcon scaleToSize:defaultHeadIcon size:CGSizeMake(200, 200)];
    self.headIcon = [defaultHeadIcon imageByScalingProportionallyToSize:CGSizeMake(200, 200)];;
    }
    self.infoDetailsArray = [NSMutableArray array];
    [self.infoDetailsArray addObject:self.headIcon];
    self.intro_albumDetailsArray = [NSMutableArray arrayWithObjects:@"未设置", @"未设置", @"未设置", nil];
    self.sectionDetailsArray = [NSMutableArray arrayWithObjects:self.infoDetailsArray, self.intro_albumDetailsArray, nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self getMemberListData];
    [self createTableView];
    [self createCompleteBtn];

}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.y = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollEnabled = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(LINEBG);
}
// 创建完成按钮
- (void)createCompleteBtn {
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _completeButton.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    
    [_completeButton setTitle:@"完 成 注 册" forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_completeButton];
    
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        
        make.right.equalTo(self.view.mas_right).offset(0);
        
        make.top.equalTo(self.view.mas_bottom).offset(-50);
        
        make.height.equalTo(@50);
        
    }];
    

}
- (void)completeAction:(UIButton *)button {
    if (self.name.length != 0) {
        if (self.sex.length != 0) {
            if (self.birth.length != 0) {
                
                if (!_bandType) {
                    
                
              NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/tour?&photo=&sec=%@&Sex=%@&TEL=%@&cmd=rgall&Nickname=%@&PWD=%@&Age=%@", self.verifyCode, [self.sex urlEncode], self.TELE, self.name, self.PWD,
                 self.birth];
                
                //网络请求管理器
                AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
                
                //JSON
                //申明返回的结果类型
                sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
                //申明请求的数据类型
                sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
                [sessionManager.requestSerializer setValue:@"JSESSIONID=6DB19FACF5EEB3ACE2D1D5F7E426D1DA" forHTTPHeaderField:@"Cookie"];
                NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
                [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
                NSDictionary *dict = @{@"Cookie": @"JSESSIONID=6DB19FACF5EEB3ACE2D1D5F7E426D1DA", @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary]};
                //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
                
                [sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSData *data = UIImagePNGRepresentation(self.headIcon);
                    
                    
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
                        [self.navigationController popToViewController:[[LoginViewController alloc] init] animated:YES];
                    } else {
                         [MBProgressHUD showTipMessageInWindow:[dic objectForKey:@"result"]];
                    }
                    NSLog(@"%@", dic);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"上传失败 %@", error);
                }];
                    
                } else {
                    if (_firstChecked == NO) {
                        
                        [self checkName];
                    } else {

                    
                    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/tour?&tokenID=%@&bandtype=%@&Sex=%@&cmd=thdrgall&photo=&Nickname=%@&Age=%@", self.tokenID, self.bandType, [self.sex urlEncode], self.name, self.birth];
                    
                    //网络请求管理器
                    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
                    
                    //JSON
                    //申明返回的结果类型
                    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
                    //申明请求的数据类型
                    sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
                    [sessionManager.requestSerializer setValue:@"JSESSIONID=6DB19FACF5EEB3ACE2D1D5F7E426D1DA" forHTTPHeaderField:@"Cookie"];
                    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
                    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
                    NSDictionary *dict = @{@"Cookie": @"JSESSIONID=", @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary]};
                    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
                    
                    [sessionManager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        
                        NSData *data = UIImagePNGRepresentation(self.headIcon);
                        
                        
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
                            [self.navigationController popViewControllerAnimated:YES];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else {
                            [MBProgressHUD showTipMessageInWindow:[dic objectForKey:@"result"]];
                        }
                        NSLog(@"%@", dic);
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        NSLog(@"上传失败 %@", error);
                    }];
                }
                }
            } else {
                 [MBProgressHUD showTipMessageInWindow:@"请设置出生日期!"];
            }
        } else {
             [MBProgressHUD showTipMessageInWindow:@"请设置性别!"];
        }
    } else {
         [MBProgressHUD showTipMessageInWindow:@"请设置昵称!"];
    }


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
        if (_bandType) {
            cell.headIcon = [UIImage getImageFromURL:_headImgURL];

        } else {
        cell.headIcon = self.sectionDetailsArray[indexPath.section][indexPath.row];
        }
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
    if (_bandType && indexPath.row == 0) {
        cell.info = _name;
    } else {
        cell.info = self.sectionDetailsArray[indexPath.section][indexPath.row];
        
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    cell.selected = YES;
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self showActionSheet];
    } else {
        if (indexPath.row == 0) {
            [self showNickNameAlertController];
        } else if (indexPath.row == 1) {
            [self showSexAlertController];
        } else {
            [self showAgePickerView];
        }
    }
}
#pragma mark - 修改昵称
- (void)showNickNameAlertController {
    double version = [[UIDevice currentDevice].systemVersion doubleValue]; //判定系统版本。
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
                    self.name = [dic objectForKey:@"name"];
                    _firstChecked = YES;
                    [self.intro_albumDetailsArray replaceObjectAtIndex:0 withObject:self.name];
                    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
- (void)checkName {
    NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/tour"];
    // Body
    NSString *bodyStr = [NSString stringWithFormat:@"cmd=isnameuse&nickname=%@", [_name urlEncode]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        
        NSDictionary *dic = result;
        
        NSNumber *flag = [dic objectForKey:@"flag"];
        NSString *msg = [dic objectForKey:@"result"];
        if ([flag isEqual:@1]) {
            _isChecked = YES;
            _firstChecked = YES;
            self.name = [dic objectForKey:@"name"];
            [self.intro_albumDetailsArray replaceObjectAtIndex:0 withObject:self.name];
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            _isChecked = NO;

            [MBProgressHUD showTipMessageInWindow:msg];
            [self showNickNameAlertController];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];

}
#pragma mark - 修改性别
- (void)showSexAlertController {
    UIAlertController *nickNameAlertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sex = @"男";
        [self.intro_albumDetailsArray replaceObjectAtIndex:1 withObject:self.sex];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sex = @"女";
        [self.intro_albumDetailsArray replaceObjectAtIndex:1 withObject:self.sex];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
      
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [nickNameAlertController addAction:maleAction];
    [nickNameAlertController addAction:femaleAction];
    [nickNameAlertController addAction:cancleAction];
    [self presentViewController:nickNameAlertController animated:true completion:nil];

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
        weakself.birth = datetimeStr;
        [weakself.intro_albumDetailsArray replaceObjectAtIndex:2 withObject:weakself.birth];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        
        [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
   editedImage = [editedImage scaleToSize:editedImage size:CGSizeMake(200, 200)];
    editedImage = [editedImage imageByScalingProportionallyToSize:CGSizeMake(200, 200)];
    
    [self.infoDetailsArray  replaceObjectAtIndex:0 withObject:editedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    self.headIcon = editedImage;
    
    
    
   
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
