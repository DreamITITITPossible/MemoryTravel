//
//  BaseModel.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end
