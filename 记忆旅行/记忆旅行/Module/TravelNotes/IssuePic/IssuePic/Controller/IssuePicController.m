//
//  IssuePicController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "IssuePicController.h"
#import <CoreLocation/CoreLocation.h>
#import "SelectAddressController.h"
#import "MyVideo_PicController.h"
@interface IssuePicController ()
<
LQPhotoPickerViewDelegate,
SelectAddressControllerDelegate,
CLLocationManagerDelegate,
UITextViewDelegate
>
{
    //备注文本View高度
    float noteTextHeight;
    int count;

    float pickerViewHeight;
    float allViewHeight;
    
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;
//位置
@property (nonatomic, strong) UIButton *locationBtn;
//是否公开
@property (nonatomic, strong) UIButton *secretBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *middleLine;
@property (nonatomic, strong) UIView *bottomLine;
//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;
@property (nonatomic, copy) NSString *locNameStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSMutableArray *locPlaceArray;
@property (nonatomic, copy) NSString *isshow;

@end

@implementation IssuePicController



- (void)startLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] > 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    
    
    CLLocation *newLocation = locations.lastObject;
    
    [manager stopUpdatingLocation];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        if (count == 0) {
        for (CLPlacemark *place in placemarks) {
                [_locPlaceArray addObject:place];
                
            if (!place.locality) {
                self.locNameStr = [NSString stringWithFormat:@"%@·%@", place.administrativeArea, place.name];
            } else {
                self.locNameStr = [NSString stringWithFormat:@"%@·%@", place.locality, place.name];
            }
            [_locationBtn setTitle:_locNameStr forState:UIControlStateNormal];
            }
            count++;
//            NSLog(@"name,%@",place.name);                       // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//            
//            NSLog(@"locality,%@",place.locality);               // 市
//            
//            NSLog(@"subLocality,%@",place.subLocality);         // 区
//            
//            NSLog(@"country,%@",place.country);                 // 国家
          
            
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"编辑旅图"];;
    self.locPlaceArray = [NSMutableArray array];
    self.locNameStr = @"不显示位置";
    self.isshow = @"0";
    count = 0;
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    /**
     *  依次设置
     */
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.dk_backgroundColorPicker =  DKColorPickerWithColors([UIColor whiteColor], JYXColor(30, 30, 30, 1));

    [self.view addSubview:_scrollView];
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 9;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    [self startLocation];
    
    
    [self initViews];
}

- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"caseLogNeedRef" object:nil];
}
- (int)convertToInt:(NSString *)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    for (int i = 0; i < [strtemp length]; i++) {
        int a = [strtemp characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) { //判断是否为中文
            strlength += 2;
        } else {
            strlength += 1;
        }
    }
    return strlength;
}
- (void)initViews{
   
    self.noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);
    
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);
    _noteTextView.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);

    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    
    self.textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    _textNumberLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);

    _textNumberLabel.text = @"180/180    ";
    
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.backgroundColor = [UIColor clearColor];
    [_locationBtn setImage:[UIImage imageNamed:@"btn_location_sample"] forState:UIControlStateNormal];
    [_locationBtn setTitle:_locNameStr forState:UIControlStateNormal];
    [_locationBtn setTitleColor:JYXColor(199, 199, 199, 1) forState:UIControlStateNormal];
    
    _locationBtn.titleLabel.font = kFONT_SIZE_13;
    [_locationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        SelectAddressController *selectAddressVC = [[SelectAddressController alloc] init];
        selectAddressVC.searchAddressArr = [NSMutableArray arrayWithArray:_locPlaceArray];
        selectAddressVC.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:selectAddressVC animated:YES];
        
    }];
    self.secretBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secretBtn.backgroundColor = [UIColor clearColor];
    [_secretBtn setImage:[UIImage imageNamed:@"btn_lock_open.png"] forState:UIControlStateNormal];
    [_secretBtn setImage:[UIImage imageNamed:@"btn_lock_close.png"] forState:UIControlStateSelected];
    
    [_secretBtn setTitle:@"谁可以看: 公开" forState:UIControlStateNormal];
     [_secretBtn setTitle:@"谁可以看: 仅自己" forState:UIControlStateSelected];
    _secretBtn.titleLabel.font = kFONT_SIZE_13;
    [_secretBtn setTitleColor:JYXColor(199, 199, 199, 1) forState:UIControlStateNormal];
    [_secretBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_secretBtn.selected == NO) {
            _isshow = @"0";
        } else {
            _isshow = @"1";
        }
        _secretBtn.selected = !_secretBtn.selected;
        
    }];
    self.topLine = [[UIView alloc] init];
    _topLine.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
    self.middleLine = [[UIView alloc] init];
    _middleLine.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
    self.bottomLine = [[UIView alloc] init];
    _bottomLine.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
    self.explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"添加图片不超过9张，文字不超过180字";
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [_submitBtn addTarget:self action:@selector(submitBtnClickedToIssue) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_noteTextBackgroudView];
    [_scrollView addSubview:_noteTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:_topLine];
    [_scrollView addSubview:_locationBtn];
    [_scrollView addSubview:_middleLine];
    [_scrollView addSubview:_secretBtn];
    [_scrollView addSubview:_bottomLine];
    [_scrollView addSubview:_explainLabel];
    [_scrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
- (void)selectAddressName:(NSString *)addressName {
    [_locationBtn setTitle:addressName forState:UIControlStateNormal];
    _locNameStr = addressName;
}
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREEN_WIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, noteTextHeight);
    
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREEN_WIDTH-10, 15);
    
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    _topLine.frame = CGRectMake(20, [self LQPhotoPicker_getPickerViewFrame].origin.y + [self LQPhotoPicker_getPickerViewFrame].size.height+10, SCREEN_WIDTH - 40, 1);
    _locationBtn.frame = CGRectMake(10, _topLine.y + _topLine.height + 1, SCREEN_WIDTH / 2 - 10, 30);
    _middleLine.frame = CGRectMake(SCREEN_WIDTH / 2 - 1, _locationBtn.centerY - 12, 1, 24);
    _secretBtn.frame = CGRectMake(_middleLine.x + _middleLine.width, _locationBtn.y, _locationBtn.width, _locationBtn.height);
    _bottomLine.frame = CGRectMake(_topLine.x, _locationBtn.y + _locationBtn.height, _topLine.width, 1);

    
    //说明文字
    _explainLabel.frame = CGRectMake(0, _bottomLine.y + _bottomLine.height + 10, SCREEN_WIDTH, 20);
    
    
    //提交按钮
//    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y + _explainLabel.frame.size.height + 30, SCREEN_WIDTH - 20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y + _explainLabel.frame.size.height + 30, SCREEN_WIDTH - 20, 40);
    
    
    allViewHeight = noteTextHeight + [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 中文算两字符时用这个方法
//    int length = [self convertToInt:textView.text];
    
    NSInteger length = textView.text.length;
    if (length >= 180) {
        _textNumberLabel.text = @"0/180    ";
        _textNumberLabel.textColor = [UIColor redColor];
    } else {
        _textNumberLabel.text = [NSString stringWithFormat:@"%ld/180    ", 180 - length];
        _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    }
    
    if (textView == self.noteTextView) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && text.length == 0) {
            return YES;
        }
        //so easy
        else if (textView.text.length >= 180) {
            textView.text = [textView.text substringToIndex:180];
            return NO;
        }
    }
    
    [self textChanged];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    // 中文算两字符时用这个方法
//    int length = [self convertToInt:textView.text];
    NSInteger length = textView.text.length;

    if (length >= 180) {
      _textNumberLabel.text = @"0/180    ";
       
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.text = [NSString stringWithFormat:@"%ld/180    ", 180 - length];
        _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    }
    self.titleStr = textView.text;
    [self textChanged];
}
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height = size.height + 10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

- (void)submitBtnClickedToIssue{
    
    if (![self checkInput]) {
        return;
    }
    
    [self submitToServer];
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_noteTextView.text.length == 0) {
        //MBhudText(self.view, @"请添加记录备注", 1);
        [MBProgressHUD showTipMessageInWindow:@"描述不能为空!"];
        return NO;
    }
    return YES;
}


#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
//    hud.contentColor = JYXColor(240, 220, 220, 1);
    hud.label.text = @"上传中...";

//    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    //大图数据
    NSMutableArray *bigImageDataArray = [self LQPhotoPicker_getBigImageDataArray];
    
    //小图数组
//    NSMutableArray *smallImageArray = [self LQPhotoPicker_getSmallImageArray];
    
    //小图数据
    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_getSmallDataImageArray];
    if (bigImageDataArray.count < 1) {
         [MBProgressHUD showTipMessageInWindow:@"请添加图片!"];
        return;
    } 
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
    if ([_locNameStr isEqualToString:@"不显示位置"]) {
        _locNameStr = @"未知地址";
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&isshow=%@&title=%@&cmd=addUserTracePic&adress=%@&tel=%@", _isshow, [_titleStr urlEncode], [_locNameStr urlEncode], userInfo.TEL];
    
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
        for (int i = 0; i < bigImageDataArray.count; i++) {
            NSData *bigImageData = bigImageDataArray[i];
            NSData *smallImageData = smallImageDataArray[i];
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
            NSString *smallfileName = [NSString stringWithFormat:@"%@%d_tk.jpg", str, i];

            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            
            [formData appendPartWithFileData:bigImageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
            [formData appendPartWithFileData:smallImageData name:@"file" fileName:smallfileName mimeType:@"image/jpg"];
        }
//        for (NSData *imageData in bigImageDataArray) {
//            
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//            
//            //上传
//            /*
//             此方法参数
//             1. 要上传的[二进制数据]
//             2. 对应网站上[upload.php中]处理文件的[字段"file"]
//             3. 要保存在服务器上的[文件名]
//             4. 上传文件的[mimeType]
//             */
//            
//        
//            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
//        }
//        for (NSData *imageData in smallImageDataArray) {
//            
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@_tk.jpg", str];
//            
//            //上传
//            /*
//             此方法参数
//             1. 要上传的[二进制数据]
//             2. 对应网站上[upload.php中]处理文件的[字段"file"]
//             3. 要保存在服务器上的[文件名]
//             4. 上传文件的[mimeType]
//             */
//  
//            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
//        }
//
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
            
        });
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功 %@", responseObject);
//        NSLog(@"%@", [responseObject objectForKey:@"result"]);
        NSDictionary *dic = responseObject;
        NSNumber *flag = [dic objectForKey:@"flag"];
        if ([flag isEqual:@1]) {
            hud.label.text = @"成功";
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            MyVideo_PicController *MyPicVC = [[MyVideo_PicController alloc] init];
            MyPicVC.videoOrPic = @"pic";
            MyPicVC.navigationItem.title = @"我的旅图";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyPicVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } else {
            hud.label.text = [dic objectForKey:@"result"];
            [hud hideAnimated:YES];
        }
        NSLog(@"%@", dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text = @"error";
        [hud hideAnimated:YES];
        NSLog(@"上传失败 %@", error);
    }];
    
    
    
}

- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
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
