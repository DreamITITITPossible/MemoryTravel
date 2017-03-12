//
//  Comments.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface Comments : BaseModel

@property (nonatomic, copy)   NSString *end;
@property (nonatomic, strong)  NSArray *content;

@end
