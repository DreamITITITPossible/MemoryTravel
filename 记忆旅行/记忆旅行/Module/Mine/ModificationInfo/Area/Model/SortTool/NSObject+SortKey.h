//
//  NSObject+SortKey.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SortKey)

/********* 为方便排序,新增一个属性 *************/
@property (nonatomic,copy)NSString *key;
@end
