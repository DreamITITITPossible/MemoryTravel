//
//  HotWords.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/2.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface HotWords : BaseModel
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *word;
@end
