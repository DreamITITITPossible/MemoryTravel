//
//  PersonalList.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VO.h"
@interface PersonalList : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) VO *vo;

@end
