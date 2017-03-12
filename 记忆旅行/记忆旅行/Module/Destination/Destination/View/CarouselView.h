//
//  CarouselView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CarouselViewDelegate <NSObject>

- (void)tapToVCAction:(NSInteger)tag;

@end
@interface CarouselView : UIView
@property (nonatomic, retain) NSArray *bannerImageArray;
@property (nonatomic, assign) id<CarouselViewDelegate>delegate;

@end
