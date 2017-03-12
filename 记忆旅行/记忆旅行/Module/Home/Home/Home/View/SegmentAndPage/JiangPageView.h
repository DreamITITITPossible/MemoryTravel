//
//  JiangPageView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiangPageView;

@protocol JiangPageViewDataSource <NSObject>

- (NSInteger)numberOfItemInPageView:(JiangPageView *)pageView;
- (UIView *)pageView:(JiangPageView *)pageView viewAtIndex:(NSInteger)index;

@end

@protocol JiangPageViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end


@interface JiangPageView : UIView

@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,assign) NSInteger numberOfItems;
@property(nonatomic,assign) BOOL scrollAnimation;
@property(nonatomic,weak) id<JiangPageViewDataSource> datasource;
@property(nonatomic,weak) id<JiangPageViewDelegate> delegate;
- (void)reloadData;
- (void)changeToItemAtIndex:(NSInteger)index;



@end


