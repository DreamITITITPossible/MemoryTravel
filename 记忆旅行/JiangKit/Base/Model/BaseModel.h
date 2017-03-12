//
//  BaseModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface BaseModel : NSObject
/**
 *  状态码
 */
@property(nonatomic,assign)NSInteger State;
/**
 *  返回的Result参数集合
 */
@property(nonatomic,strong) NSObject *Result;

/**
 *  基类初始化方法
 *
 *  @param dic model对应的字典
 *
 *  @return id
 */


- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 *  基类构造器方法
 *
 *  @param dic model对应的字典
 *
 *  @return id
 */
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
NS_ASSUME_NONNULL_END
