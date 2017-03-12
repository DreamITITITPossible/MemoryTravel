//
//  PersonalHomepageHeaderView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseView.h"
#import "PersonalInfo.h"

@protocol HeaderViewDelegate <NSObject>

- (void)ClickFans_AttentionBtnPushToVCWithType:(NSString *)type TouristID:(NSString *)touristID;

@end
@interface PersonalHomepageHeaderView : BaseView
@property (nonatomic, strong) PersonalInfo *personalInfo;
@property (nonatomic, weak) id<HeaderViewDelegate> delegate;
@end
