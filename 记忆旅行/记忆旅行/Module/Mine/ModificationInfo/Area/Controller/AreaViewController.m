//
//  AreaViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "AreaViewController.h"
#import "Province.h"
#import "City.h"
#import "SortTool.h"
#import <CoreLocation/CoreLocation.h>
@interface AreaViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
CLLocationManagerDelegate
>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *sortArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *locNameStr;
@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortArr = [NSMutableArray array];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"地区"];;
    self.locNameStr = @" 未定位";
    [self startLocation];
    [self getAreaData];
    [self creatTableView];
    
    // Do any additional setup after loading the view.
}
-(void)startLocation{
    
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
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    
    
    CLLocation *newLocation = locations.lastObject;
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
            for (CLPlacemark *place in placemarks) {
                
                if (!place.locality) {
                    self.locNameStr = place.subLocality;
                } else {
                    self.locNameStr =  place.locality;
                }

                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.textLabel.text = self.locNameStr;
             
            }
            //            NSLog(@"name,%@",place.name);                       // 位置名
            //            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
            //            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
            //
            //            NSLog(@"locality,%@",place.locality);               // 市
            //
            //            NSLog(@"subLocality,%@",place.subLocality);         // 区
            //
            //            NSLog(@"country,%@",place.country);                 // 国家
            
        
        
    }];
    [manager stopUpdatingLocation];

}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_sectionIndexBackgroundColorPicker = DKColorPickerWithKey(BG);
//    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(LINEBG);
    [self.view addSubview:_tableView];
}
- (void)getAreaData {
    
    NSString *urlString =@"http://www.yundao91.cn/ssh2/city?&cmd=citylist";
    // Body
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlString body:nil headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
        NSDictionary *dic = result;
        NSMutableArray *allCityNameArr = [NSMutableArray array];
        NSNumber *flag = [dic objectForKey:@"flag"];
        if ([flag isEqual:@1]) {

            NSArray *provinceArr = [Province mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"result"]];
            for (Province *province in provinceArr) {
                for (City *city in province.City) {
                    city.cityName = [city.cityName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [allCityNameArr addObject:city.cityName];
            
                         }
            }
        }
        [allCityNameArr addObject:_locNameStr];
        self.sortArr = [SortTool sortStrings:allCityNameArr withSortType:SortResultTypeDoubleValues];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return _sortArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    
    return [[_sortArr[section] objectForKey:SortToolValueKey] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCell
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    
    static NSString *GroupedTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:GroupedTableIdentifier];
    }
    NSArray *arr = [_sortArr[section] objectForKey:SortToolValueKey];
    NSString *cityName = arr[row];
    if (section == 0) {
        cell.textLabel.text = [cityName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        cell.textLabel.text = cityName;
    }
 
    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
    //    cell.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434);
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    
    return cell;
}
//区头的字体颜色设置

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
//    header.contentView.backgroundColor = [UIColor yellowColor];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //这个方法用来告诉表格第section分组的名称
    if (section == 0) {
        return @"当前定位";
    }
    
    return [_sortArr[section] objectForKey:SortToolKey];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [_sortArr[indexPath.section] objectForKey:SortToolValueKey];
    NSString *cityName = arr[indexPath.row];
    if (indexPath.section == 0) {
        if ([_locNameStr isEqualToString:@" 未定位"]) {
            [MBProgressHUD showTipMessageInWindow:@"当前未定位"];
        } else {
            [self.delegate getAddress:_locNameStr];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.delegate getAddress:cityName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //返回省份的数组
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < _sortArr.count; i++) {
        NSString *str = [_sortArr[i] objectForKey:SortToolKey];
        [arr addObject:str];

    }
    return arr;;
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
