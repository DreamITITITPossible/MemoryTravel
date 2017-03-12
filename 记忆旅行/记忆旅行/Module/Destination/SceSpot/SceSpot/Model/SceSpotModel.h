//
//  SceSpotModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface SceSpotModel : BaseModel
@property (nonatomic,copy)   NSString *SceName;
@property (nonatomic,copy)   NSString *MapMark;
@property (nonatomic,copy)   NSString *currentDate;
@property (nonatomic,copy)   NSString *SceLatitude;
@property (nonatomic,copy)   NSString *SceLongitude;
@property (nonatomic,copy)   NSString *sceInforUrl;
@end
