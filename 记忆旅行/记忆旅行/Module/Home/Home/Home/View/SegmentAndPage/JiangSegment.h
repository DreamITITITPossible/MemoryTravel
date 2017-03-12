//
//  JiangSegment.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiangSegment;

@protocol JiangSegmentDelegate <NSObject>
- (void)JiangSegment:(JiangSegment *)segment didSelectIndex:(NSInteger)index;

@end

@interface JiangSegment : UIControl
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<JiangSegmentDelegate> delegate;

- (void)updateChannels:(NSArray *)array;
- (void)didChangeToIndex:(NSInteger)index;

@end
