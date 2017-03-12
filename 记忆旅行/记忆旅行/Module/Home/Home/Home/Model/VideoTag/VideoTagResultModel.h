//
//  VideoTagResultModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VideoTagResultModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *modifyDate;

@property (nonatomic, strong) NSNumber *sortIndex;
@property (nonatomic, strong) NSNumber *tagIndex;
@property (nonatomic, strong) NSNumber *showType;

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, strong) NSArray *child;




@end
