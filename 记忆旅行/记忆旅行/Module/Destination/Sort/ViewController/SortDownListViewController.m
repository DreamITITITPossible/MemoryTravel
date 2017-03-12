//
//  SortDownListViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SortDownListViewController.h"
@interface SortDownListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, retain) UITableView *districtTableView;
@property (nonatomic, strong) UISegmentedControl *selectSegC;
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;

@end

@implementation SortDownListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self createSegmentControlAndBackgroundView];
    [self creatRelatedTableView];
    
    
}

-(void)creatRelatedTableView{
    
    
    //地区及智能筛选公用tableView设置代理
    self.districtTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _selectSegC.x + _selectSegC.height , SCREEN_WIDTH, self.view.height - _selectSegC.x - _selectSegC.height) style:UITableViewStylePlain];
    _districtTableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    _districtTableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    _districtTableView.showsVerticalScrollIndicator=YES;
    _districtTableView.dataSource=self;
    _districtTableView.delegate=self;
    _districtTableView.bounces = NO;
    [self.view addSubview:_districtTableView];
    
}
-(void)createSegmentControlAndBackgroundView{
    
    //背景View设置（用来在选择时变暗）
    
    
    //母版View设置（用来添加tableView）
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.34];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
}

-(void)appearOrHidden:(id)sender{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.view.frame;
        rect.size.height = _sortArray.count * 50;
        _districtTableView.frame = rect;
        
        
    }];
    
    _districtTableView.hidden = NO;
    [_districtTableView reloadData];
    [self.view bringSubviewToFront:_districtTableView];
    
    [self backgroundView_Appear:nil];
    
}
#pragma mark--显示下拉列表要执行的方法
-(void)backgroundView_Appear:(id)sender{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [UIView animateWithDuration:0.2  animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)backgroundView_hidden:(id)sender{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.5  animations:^{
        CGRect rect = self.view.frame;
        rect.size.height = self.view.frame.size.height * 5 / 9;
        _districtTableView.frame = rect;
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
    return _sortArray.count;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *identifier_D = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_D];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_D];
        //                cell.backgroundColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
    }
    if (indexPath == _selectedIndexPath) {
       
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(BTNGREENBG);
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } 
    cell.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.textLabel.text = _sortArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[_districtTableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.textColor=[UIColor blackColor];
    _selectedIndexPath = indexPath;
    
    UITableViewCell *newSelectedCell = [_districtTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [newSelectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self backgroundView_hidden:nil];
    self.isSelected = NO;
    [self.delegate getSortInfomationWithSortNum:indexPath.row];
    


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
