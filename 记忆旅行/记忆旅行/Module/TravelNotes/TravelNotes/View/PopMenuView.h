//
//  PopMenuView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickShareButtonBlock)(NSInteger tag);
@interface PopMenuView : UIView
- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray didShareButtonBlock:(ClickShareButtonBlock)saveBlock;
- (void)show;
@end
