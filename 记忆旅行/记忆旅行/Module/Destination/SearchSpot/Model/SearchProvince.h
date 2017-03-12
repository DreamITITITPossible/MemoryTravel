//
//  SearchProvince.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/4.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface SearchProvince : BaseModel
@property(nonatomic,strong)  NSMutableArray *citys;
@property (nonatomic,copy)   NSString *ProvinceID;
@property (nonatomic,copy)   NSString *ProvinceName;

@end
