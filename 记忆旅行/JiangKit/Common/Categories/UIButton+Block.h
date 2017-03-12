//
//  UIButton+Block.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define defaultInterval .5//默认时间间隔

typedef void (^Callback)();

@interface UIButton (Block)

@property(nonatomic, assign) NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic, assign) BOOL isIgnoreEvent;//YES不允许点击NO允许点击
- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(Callback)block;
@end
