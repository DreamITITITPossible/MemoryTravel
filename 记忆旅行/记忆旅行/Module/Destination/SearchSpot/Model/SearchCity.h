//
//  SearchCity.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/4.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface SearchCity : BaseModel
@property (nonatomic,copy)   NSString *ProvinceID;
@property (nonatomic,copy)   NSString *CityID;
@property (nonatomic,copy)   NSString *CityName;

@end
