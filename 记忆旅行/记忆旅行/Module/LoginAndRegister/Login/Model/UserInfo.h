//
//  UserInfo.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : NSObject<NSCoding>
@property (nonatomic,copy)   NSString *QQ;
@property (nonatomic,copy)   NSString *Wechat;
@property (nonatomic,copy)   NSString *Age1;
@property (nonatomic,copy)   NSString *Email;
@property (nonatomic,copy)   NSString *Photo;
@property (nonatomic,copy)   NSString *backpic;
@property (nonatomic,copy)   NSString *extr;
@property (nonatomic,copy)   NSString *kidneyname;
@property (nonatomic,copy)   NSString *Address;
@property (nonatomic,copy)   NSString *Nickname;
@property (nonatomic,copy)   NSString *TEL;
@property (nonatomic,copy)   NSString *Age;
@property (nonatomic,copy)   NSString *Sex;
@property (nonatomic,copy)   NSString *Weibo;
@property (nonatomic,copy)   NSString *TourID;
@property (nonatomic, strong) UIImage *headImage;
+ (UserInfo *)getUserDetailsInfomation;

@end
