//
//  FilterDownListViewController.m
//  FindTraining
//
//  Created by Jiang on 16/10/10.
//  Copyright © 2016年 Yuxiao Jiang. All rights reserved.
//

#import "FilterDownListViewController.h"
#import "FilterModel.h"
#import "SearchCity.h"
#import "SearchProvince.h"
#import "Grade.h"
@interface FilterDownListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property(nonatomic, strong)NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *gradeArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, retain) UITableView *districtTableView;
@property (nonatomic, retain) UITableView *leftDistrict_TableView;
@property (nonatomic, retain) UITableView *rightDetail_TableView;
@property (nonatomic, assign) NSInteger leftToRight;
@property (nonatomic, assign) CGRect rightFrame;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) NSInteger skillLeftRow;
@property (nonatomic, retain) FilterModel *filter;
@end

@implementation FilterDownListViewController
- (void)loadView {
    [super loadView];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.filter = [[FilterModel alloc] init];
    _filter.provinceID = @"";
    _filter.cityID = @"";
    _filter.grade = @"";
    [self getAreaListData];
    [self getGrade];
    [self createSegmentControlAndBackgroundView];
    [self creatRelatedTableView];
    
    
    
}

-(void)creatRelatedTableView{
    
    //联动左右tableView设置
    self.leftFrame = self.view.frame;
    _leftFrame.size.height = 0;
    _leftFrame.size.width = self.view.frame.size.width * 2 / 5;
    
    self.leftDistrict_TableView=[[UITableView alloc]initWithFrame:_leftFrame style:UITableViewStylePlain];
    _leftDistrict_TableView.showsVerticalScrollIndicator = YES;
    _leftDistrict_TableView.dataSource = self;
    _leftDistrict_TableView.delegate = self;
    _leftDistrict_TableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _leftDistrict_TableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);

    [self.view addSubview:_leftDistrict_TableView];
    
    self.rightFrame = self.view.frame;
    _rightFrame.origin.x = _leftFrame.origin.x + _leftFrame.size.width;
    _rightFrame.size.height = 0;

    _rightFrame.size.width = self.view.frame.size.width * 3 / 5;
    
    _rightDetail_TableView = [[UITableView alloc]initWithFrame:_rightFrame style:UITableViewStylePlain];
    _rightDetail_TableView.showsVerticalScrollIndicator = YES;
    _rightDetail_TableView.dataSource = self;
    _rightDetail_TableView.delegate = self;
    _rightDetail_TableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);    [self.view addSubview:_rightDetail_TableView];
    _rightDetail_TableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);

    
    //地区及智能筛选公用tableView设置代理
    self.districtTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, _selectSegC.x + _selectSegC.height , SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    _districtTableView.showsVerticalScrollIndicator=YES;
    _districtTableView.dataSource=self;
    _districtTableView.delegate=self;
    _districtTableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _districtTableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    [self.view addSubview:_districtTableView];
    
}
- (void)getAreaListData {
 
      NSString *urlString = @"http://www.yundao91.cn/ssh2/operation?&cmd=querySceProvince";
    [JYXNetworkingTool getWithUrl:urlString params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.areaArr = [NSMutableArray array];
            SearchProvince *firstProvince = [[SearchProvince alloc] init];
            firstProvince.ProvinceName = @"所有区域";
            firstProvince.ProvinceID = @"";
            firstProvince.citys = [NSMutableArray array];
            
           
            _areaArr = [SearchProvince mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_areaArr insertObject:firstProvince atIndex:0];
            for (SearchProvince *province in _areaArr) {
                SearchCity *city = [[SearchCity alloc] init];
                city.ProvinceID = province.ProvinceID;
                city.CityID = @"";
                city.CityName = @"全部";
                [province.citys insertObject:city atIndex:0];
                
            }
          
            [_leftDistrict_TableView reloadData];
            [_rightDetail_TableView reloadData];
            
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.areaArr = [NSMutableArray array];
            SearchProvince *firstProvince = [[SearchProvince alloc] init];
            firstProvince.ProvinceName = @"所有区域";
            firstProvince.ProvinceID = @"";
            firstProvince.citys = [NSMutableArray array];
            
            
            _areaArr = [SearchProvince mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_areaArr insertObject:firstProvince atIndex:0];
            for (SearchProvince *province in _areaArr) {
                SearchCity *city = [[SearchCity alloc] init];
                city.ProvinceID = province.ProvinceID;
                city.CityID = @"";
                city.CityName = @"全部";
                [province.citys insertObject:city atIndex:0];
            }
            [_leftDistrict_TableView reloadData];
            [_rightDetail_TableView reloadData];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}
- (void)getGrade {
    NSString *urlString = @"http://www.yundao91.cn/ssh2/operation?&cmd=querySceGread&type=-1";
    [JYXNetworkingTool getWithUrl:urlString params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.gradeArr = [NSMutableArray array];
            Grade *grade = [[Grade alloc] init];
            grade.gradeName = @"全部";
            grade.ID = @"";
            grade.dr = @"0";
            _gradeArr = [Grade mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_gradeArr insertObject:grade atIndex:0];
            [_districtTableView reloadData];
            
        }

    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.gradeArr = [NSMutableArray array];
            Grade *grade = [[Grade alloc] init];
            grade.gradeName = @"全部";
            grade.ID = @"";
            grade.dr = @"0";
            _gradeArr = [Grade mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [_gradeArr insertObject:grade atIndex:0];
            [_districtTableView reloadData];

        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}

-(void)createSegmentControlAndBackgroundView{

    _selectSegC=[[UISegmentedControl alloc]initWithItems:_segCArr];
    _selectSegC.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor blackColor]);
    _selectSegC.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    
    _selectSegC.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:_selectSegC];
    
    [_selectSegC addTarget:self action:@selector(appearOrHidden2:) forControlEvents:UIControlEventValueChanged];
    
    //背景View设置（用来在选择时变暗）
    
    
    //母版View设置（用来添加tableView）
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.34];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
}

-(void)appearOrHidden2:(id)sender{
    UISegmentedControl *control=(UISegmentedControl*)sender;
    _districtTableView.y = 40;
    _leftDistrict_TableView.y = 40;
    _rightDetail_TableView.y = 40;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 40;
        rect.size.height = 50 * 6;
        _districtTableView.frame = rect;

        _leftFrame = self.view.frame;
        _leftFrame.size.width = self.view.frame.size.width * 2 / 5;
        _leftFrame.origin.y = 40;

        _leftFrame.size.height = 50 * 6;
        
        _leftDistrict_TableView.frame = _leftFrame;
        _rightFrame = self.view.frame;
        _rightFrame.origin.x = _leftFrame.origin.x + _leftFrame.size.width;
        _rightFrame.size.height = 50 * 6;
        _rightFrame.origin.y = 40;

        _rightFrame.size.width = self.view.frame.size.width * 3 / 5;
        _rightDetail_TableView.frame = _rightFrame;
        
        
    }];
    
    
    switch (control.selectedSegmentIndex) {
           case 0:
            //选中LeftTableView的第一行
            [self tableView:_leftDistrict_TableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

            
            
            _districtTableView.hidden = YES;
            
            [_leftDistrict_TableView reloadData];
            [self.view bringSubviewToFront:_leftDistrict_TableView];
            [_rightDetail_TableView  reloadData];
            [self.view bringSubviewToFront:_rightDetail_TableView];

            [self backgroundView_Appear:nil];
            break;
        case 1:
            //添加性别排序数据源
            _districtTableView.hidden = NO;
            [_districtTableView reloadData];
            [self.view bringSubviewToFront:_districtTableView];
            //            NSLog(@"SegmentIndex%ld",_selectSegC.selectedSegmentIndex);
            
            [self backgroundView_Appear:nil];
            break;

        default:
            break;
    };
    [self.delegate clickSegResignFirstResponder];
}
#pragma mark--显示下拉列表要执行的方法
-(void)backgroundView_Appear:(id)sender{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
   
}

-(void)backgroundView_hidden:(id)sender{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [UIView animateWithDuration:0.5  animations:^{
        CGRect rect = self.view.frame;
    
        rect.origin.y = _selectSegC.y + _selectSegC.height;
        rect.size.height = 0;
        _districtTableView.frame = rect;
        _leftFrame = self.view.frame;
        _leftFrame.size.height = 0;
        _leftFrame.origin.y = _selectSegC.y + _selectSegC.height;
        _leftFrame.size.width = self.view.frame.size.width * 2 / 5;
        _leftDistrict_TableView.frame = _leftFrame;
        _rightFrame = self.view.frame;
        _rightFrame.origin.x = _leftFrame.origin.x + _leftFrame.size.width;
        _rightFrame.size.width = self.view.frame.size.width * 3 / 5;
        _rightFrame.origin.y = _selectSegC.y + _selectSegC.height;
        _rightFrame.size.height = 0;
//        NSLog(@"%f, %f, %f, %f", _leftDistrict_TableView.x, _leftDistrict_TableView.y, _leftDistrict_TableView.width, _leftDistrict_TableView.height);

        _rightDetail_TableView.frame = _rightFrame;
    } completion:^(BOOL finished) {

    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self backgroundView_hidden:nil];
    self.isSelected = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _districtTableView) {
        return  _gradeArr.count;
    }else if ([tableView isEqual:_leftDistrict_TableView]){
        return _areaArr.count;
    }
    
        return _leftToRight;
    
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _districtTableView) {
        static NSString *identifier_D = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_D];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_D];
            //                cell.backgroundColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
        }
                Grade *grade = [[Grade alloc] init];
                grade = _gradeArr[indexPath.row];
                cell.textLabel.text = grade.gradeName;
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        cell.textLabel.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
        return cell;
        
    } else if (tableView == _leftDistrict_TableView){
        
        
        static NSString *identifier_L = @"cell_L";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_L];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_L];
        
        }
        SearchProvince *province = _areaArr[indexPath.row];
        cell.textLabel.text = province.ProvinceName;
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        cell.textLabel.dk_tintColorPicker = DKColorPickerWithKey(TEXT);

        return cell;
    }else
    {
        static NSString *identifier_R = @"cell_R";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_R];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_R];
        }
        NSLog(@"%ld", indexPath.row);
        SearchProvince *province = _areaArr[_skillLeftRow];
        SearchCity *city = province.citys[indexPath.row];
        cell.textLabel.text = city.CityName;
        cell.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230, 230, 230, 1), [UIColor lightGrayColor]);
        cell.textLabel.dk_tintColorPicker = DKColorPickerWithKey(TEXT);

        return cell;
    }
    
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_districtTableView) {
      
                if (indexPath.row == 0) {
                      [_selectSegC setTitle:@"等级" forSegmentAtIndex:1];
                } else { [_selectSegC setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forSegmentAtIndex:1];
                }
        [self backgroundView_hidden:nil];
        self.isSelected = NO;
        _selectSegC.selectedSegmentIndex = UISegmentedControlNoSegment;
                Grade *grade = _gradeArr[indexPath.row];
                _filter.grade = grade.ID;
           
    }else if(tableView==_leftDistrict_TableView ){
            SearchProvince *province = _areaArr[indexPath.row];
          
            _skillLeftRow = indexPath.row;
            
            _leftToRight = province.citys.count;
            [_rightDetail_TableView reloadData];
    } else {
            if (_skillLeftRow == 0 ) {
                 [_selectSegC setTitle:@"地区" forSegmentAtIndex:0];
            } else  if (indexPath.row == 0) {
                SearchProvince *province = _areaArr[_skillLeftRow];
                [_selectSegC setTitle:province.ProvinceName forSegmentAtIndex:0];
            } else {
            [_selectSegC setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forSegmentAtIndex:0];
            }
            SearchProvince *province = _areaArr[_skillLeftRow];
            SearchCity *city = province.citys[indexPath.row];
            _filter.cityID = city.CityID;
            _filter.provinceID = city.ProvinceID;
            
            
            [self backgroundView_hidden:nil];
            self.isSelected = NO;
            _selectSegC.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
    if (tableView != self.leftDistrict_TableView) {
        
        [self.delegate getFilterInfomationWithFilterModel:_filter];
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
