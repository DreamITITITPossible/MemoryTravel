//
//  ResetPWDViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"

@protocol ResetPWDViewControllerDelegate <NSObject>

- (void)resetPasswordOfTEL: (NSString *)tel;

@end

@interface ResetPWDViewController : BaseNavViewController
@property (nonatomic, assign) id<ResetPWDViewControllerDelegate> delegate;
@end
