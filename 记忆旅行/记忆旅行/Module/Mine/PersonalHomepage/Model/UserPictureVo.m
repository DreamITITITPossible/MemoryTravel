//
//  UserPictureVo.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UserPictureVo.h"

@implementation UserPictureVo
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
