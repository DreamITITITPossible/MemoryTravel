//
//  VO.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "VO.h"

@implementation VO
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}
+ (NSDictionary *)objectClassInArray {
    return @{
             @"picList" : @"PicList",
             
             };
}
@end
