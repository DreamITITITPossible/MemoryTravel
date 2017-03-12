//
//  SelectAddressController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SelectAddressController.h"
#import <MapKit/MapKit.h>
@interface SelectAddressController ()
<
UISearchResultsUpdating,
UISearchControllerDelegate,
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, copy) NSString *searchName;
@property (nonatomic, assign) BOOL isUpState;
@end

@implementation SelectAddressController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.delegate = nil;
    _searchController.active = NO;;

}
- (void)createSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.showsCancelButton = NO;
    
    _searchController.searchBar.backgroundImage = [UIImage new];
    _searchController.searchBar.layer.cornerRadius = 22;
    _searchController.searchBar.layer.masksToBounds = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 44);
    _searchController.searchBar.placeholder = @"搜索位置";
    _searchController.searchBar.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    _searchController.searchBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    _searchController.searchBar.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor]);
    [_searchController.searchBar sizeToFit];
}


- (void)didPresentSearchController:(UISearchController *)searchController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _searchController.searchBar.showsCancelButton = NO;
        
    });
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchController.searchBar resignFirstResponder];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //    NSString *searchString = _searchController.searchBar.text;
    //    NSLog(@"%@", searchString);
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
}

#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchName = searchBar.text;
    //    self.searchController.active = NO;
    [self.tableView.mj_header beginRefreshing];
    _isUpState = NO;
    [self addressSearchWithKeywords:searchBar.text];
    [self.searchController.searchBar resignFirstResponder];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"icon_nav_back" HighLightedImageName:@"icon_nav_back" Size:CGSizeMake(12, 21) targetBlock:^{
        _searchController.active = NO;
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.navigationItem.leftBarButtonItem = backItem;
    [self createSearchController];
    self.navigationItem.titleView =[UILabel getTitleViewWithTitle:@"选择地址"];
    _searchName = @"";
    self.page = 1;
    [self createTableView];
    
    // Do any additional setup after loading the view.
}
- (void)addressSearchWithKeywords:(NSString *)keywords {
//    MKCoordinateRegion region = _mapView.region;
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init] ;
//    localSearchRequest.region = region;
    localSearchRequest.naturalLanguageQuery = keywords;//搜索关键词
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error)
        {
            NSLog(@"error info：%@",error);
        }
        else
        {
            if (_searchAddressArr.count > 0) {
                [_searchAddressArr removeAllObjects];
            }
            for (MKMapItem *mapItem in response.mapItems) {
                [_searchAddressArr addObject:mapItem.placemark];
                NSLog(@"%@", mapItem.placemark.locality);
            }
            
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            _tableView.mj_footer.state = MJRefreshStateIdle;
          
        }
            
            
            
        }];
//    //创建地理编码
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //正向地理编码
//    [geocoder geocodeAddressString:keywords inRegion:nil  completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error == nil) {
//                    //解析地理位置成功
//                    if (_searchAddressArr.count > 0) {
//                        [_searchAddressArr removeAllObjects];
//                    }
//                    //成功后遍历数组
//                    for (CLPlacemark *place in placemarks) {
//                             [_searchAddressArr addObject:place];
//                        
//                         }
//                [_tableView reloadData];
//                [_tableView.mj_footer endRefreshing];
//                _tableView.mj_footer.state = MJRefreshStateIdle;
//                } else {
//                        NSLog(@"正向地理编码解析失败");
//                    }
//        }];
   
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    [self.view addSubview:_tableView];
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isUpState = YES;
        if (self.page < (_searchAddressArr.count + 1) / 20) {
            self.page = _page + 1;
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
        } else {
            [_tableView.mj_footer endRefreshing];
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _searchController.searchBar;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((_searchAddressArr.count + 1) <= 20) {
        return (_searchAddressArr.count + 1);
    } else if ((_searchAddressArr.count + 1 - _page * 20) / 20 > 1){
        return _page * 20;
    }
    return _searchAddressArr.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = [NSString stringWithFormat:@"searchAddressCell%ld%ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);


    if (indexPath.row == 0) {
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(BTNGREENBG);
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.textLabel.text = @"不显示位置";
        cell.detailTextLabel.text = @"  ";
        
    } else {
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    CLPlacemark *place = _searchAddressArr[indexPath.row - 1];
    if (!place.locality) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@·%@", place.administrativeArea, place.name];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@·%@", place.locality, place.name];
    }
        cell.detailTextLabel.text = place.thoroughfare;
    }
    cell.detailTextLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor lightGrayColor],[UIColor grayColor]);

    cell.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate selectAddressName:cell.textLabel.text];
    _searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
