//
//  AreaViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"

@protocol AreaViewControllerDelegate <NSObject>

- (void)getAddress:(NSString *)address;

@end
@interface AreaViewController : BaseNavViewController
@property (nonatomic, weak) id<AreaViewControllerDelegate> delegate;
@end
