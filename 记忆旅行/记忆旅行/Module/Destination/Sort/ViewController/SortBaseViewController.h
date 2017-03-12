//
//  SortBaseViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"
#import "SortDownListViewController.h"

@interface SortBaseViewController : BaseNavViewController
<
SortDownListViewControllerDelegate
>

@property (nonatomic, retain) SortDownListViewController *sortVC;
@end
