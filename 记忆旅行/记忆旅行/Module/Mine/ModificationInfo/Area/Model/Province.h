//
//  Province.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface Province : BaseModel
@property(nonatomic,strong)  NSArray *City;
@property (nonatomic,copy)   NSString *provinceId;
@property (nonatomic,copy)   NSString *provinceName;

@end
