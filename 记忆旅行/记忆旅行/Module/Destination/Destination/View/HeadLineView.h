//
//  HeadLineView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadLineDelegate <NSObject>

@optional
- (void)refreshHeadLine:(NSInteger)currentIndex;

@end
@interface HeadLineView : UIView
@property(nonatomic,assign)NSInteger CurrentIndex;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)id<HeadLineDelegate>delegate;
@end
