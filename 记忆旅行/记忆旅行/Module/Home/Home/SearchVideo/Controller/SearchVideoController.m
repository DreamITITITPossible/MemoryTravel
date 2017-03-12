
//
//  SearchVideoController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/1.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchVideoController.h"
#import "PYSearch.h"
#import "SearchVideoResultController.h"
@interface SearchVideoController ()

@end

@implementation SearchVideoController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.dk_tintColorPicker = DKColorPickerWithKey(BTNGREENBG);
    self.searchBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);

}


- (void)createSearchController {
    
    
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
