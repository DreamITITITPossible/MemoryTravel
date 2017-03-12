//
//  SortBaseViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SortBaseViewController.h"

@interface SortBaseViewController ()

@end

@implementation SortBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    UIBarButtonItem *sortItem = [UIBarButtonItem getBarButtonItemWithImageName:@"demand_list_sort" HighLightedImageName:@"demand_list_sort" Size:CGSizeMake(21, 21) targetBlock:^{
        
        if (_sortVC.isSelected == NO) {
            [_sortVC appearOrHidden:nil];
            _sortVC.isSelected = !_sortVC.isSelected;
        } else {
            [_sortVC backgroundView_hidden:nil];
            _sortVC.isSelected = !_sortVC.isSelected;
        }
    }];
    self.navigationItem.rightBarButtonItem = sortItem;

   
    
    self.sortVC = [[SortDownListViewController alloc] init];
    _sortVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    _sortVC.delegate = self;
    
    
    
 
    
    
    // Do any additional setup after loading the view.
}
- (void)getSortInfomationWithSortNum:(NSInteger)sortNum {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self addChildViewController:_sortVC];
    [self.view addSubview:_sortVC.view];
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
