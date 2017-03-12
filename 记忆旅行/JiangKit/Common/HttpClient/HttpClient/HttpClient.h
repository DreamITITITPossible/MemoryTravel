//
//  HttpClient.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^successBlock)(id result);

typedef void(^failureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, JYX_ResponseStyle) {
    JYX_JSON,
    JYX_DATA,
    JYX_XML,
};

typedef NS_ENUM(NSUInteger, JYX_RequestStyle) {
    JYX_BodyString,
    JYX_BodyJSON,
};

@interface HttpClient : NSObject
- (void)GET:(NSString *)url body:(id)body headerFile:(NSDictionary *)headers response:(JYX_ResponseStyle)responseStyle isShowHub:(BOOL)isShow success:(successBlock)success failure:(failureBlock)failure;

- (void)POST:(NSString *)url
        body:(id)body
   bodyStyle:(JYX_RequestStyle)bodyStyle
  headerFile:(NSDictionary *)headers
    response:(JYX_ResponseStyle)responseStyle
   isShowHub:(BOOL)isShow
     success:(successBlock)success
     failure:(failureBlock)failure;


@end
