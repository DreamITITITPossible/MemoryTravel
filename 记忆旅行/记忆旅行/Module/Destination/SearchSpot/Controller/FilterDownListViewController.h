//
//  FilterDownListViewController.h
//  FindTraining
//
//  Created by Jiang on 16/10/10.
//  Copyright © 2016年 Yuxiao Jiang. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterModel.h"

@protocol FilterDownListViewControllerDelegate <NSObject>

- (void)getFilterInfomationWithFilterModel:(FilterModel *)filter;
- (void)clickSegResignFirstResponder;

@end

@interface FilterDownListViewController : BaseViewController
-(void)backgroundView_hidden:(id)sender;
-(void)backgroundView_Appear:(id)sender;
@property (nonatomic, retain) NSArray *segCArr;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) id<FilterDownListViewControllerDelegate>delegate;

@property (nonatomic, strong) UISegmentedControl *selectSegC;
@end
