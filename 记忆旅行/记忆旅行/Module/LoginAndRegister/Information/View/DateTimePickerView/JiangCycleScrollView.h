//
//  JiangCycleScrollView.h
//  FindTraining
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Yuxiao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JiangCycleScrollViewDelegate;
@protocol JiangCycleScrollViewDatasource;

@interface JiangCycleScrollView : UIView
<
UIScrollViewDelegate
>
{
    UIScrollView *_scrollView;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<JiangCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<JiangCycleScrollViewDelegate> delegate;

- (void)setCurrentSelectPage:(NSInteger)selectPage; //设置初始化页数
- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol JiangCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(JiangCycleScrollView *)clickedView atIndex:(NSInteger)index;
- (void)scrollviewDidChangeNumber;

@end

@protocol JiangCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages:(JiangCycleScrollView *)scrollView;
- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(JiangCycleScrollView *)scrollView;

