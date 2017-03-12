//
//  VideoTagResultModel.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "VideoTagResultModel.h"

@implementation VideoTagResultModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}

+ (NSDictionary *)objectClassInArray {
        return @{
                 @"child" : @"VideoTagChildModel"
                 };
    
}
@end
