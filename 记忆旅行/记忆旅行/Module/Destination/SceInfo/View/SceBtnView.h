//
//  SceBtnView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SceBtnViewDelegate <NSObject>

- (void)ClickBtnPushToVCWithIndex:(NSInteger)index;

@end
@interface SceBtnView : UIView
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<SceBtnViewDelegate> delegate;
@end
