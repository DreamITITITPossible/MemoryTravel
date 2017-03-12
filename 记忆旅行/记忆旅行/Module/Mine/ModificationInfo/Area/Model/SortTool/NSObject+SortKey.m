//
//  NSObject+SortKey.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "NSObject+SortKey.h"
#import <objc/runtime.h>

@implementation NSObject (SortKey)
- (void)setKey:(NSString *)key {
    
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)key {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
