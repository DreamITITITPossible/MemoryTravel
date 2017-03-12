//
//  NSDictionary+Check.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "NSDictionary+Categories.h"


@implementation NSDictionary (Categories)

+(BOOL)isEmpty:(NSDictionary *)dict{
    if(dict == nil || dict.count == 0)
        return YES;
    return NO;
}

@end
