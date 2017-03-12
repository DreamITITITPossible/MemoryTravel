//
//  FriendsVO.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "FriendsVO.h"

@implementation FriendsVO
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
