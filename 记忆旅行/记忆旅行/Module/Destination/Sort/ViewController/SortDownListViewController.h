//
//  SortDownListViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseViewController.h"
@protocol SortDownListViewControllerDelegate <NSObject>

- (void)getSortInfomationWithSortNum:(NSInteger)sortNum;

@end
@interface SortDownListViewController : BaseViewController
-(void)backgroundView_hidden:(id)sender;
-(void)backgroundView_Appear:(id)sender;
-(void)appearOrHidden:(id)sender;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, retain) NSArray *sortArray;


@property (nonatomic, assign) id<SortDownListViewControllerDelegate>delegate;
@end
