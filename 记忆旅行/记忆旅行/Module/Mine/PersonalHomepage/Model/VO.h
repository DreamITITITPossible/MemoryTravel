//
//  VO.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraVideoVo.h"
#import "UserPictureVo.h"
@interface VO : NSObject

@property (nonatomic,copy)   NSString *modifyDate;
@property (nonatomic,assign) BOOL isVote;
@property (nonatomic,copy)   NSString *focus;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *isshow;
@property (nonatomic,copy)   NSString *index;
@property (nonatomic,copy)   NSString *userID;
@property (nonatomic,copy)   NSString *YSofficial;
@property (nonatomic,copy)   NSString *Sex;
@property (nonatomic,copy)   NSString *reviews;
@property (nonatomic,copy)   NSString *type;
@property (nonatomic,copy)   NSString *frameState;
@property (nonatomic,strong)  CameraVideoVo *cameraVideoVo;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *Nickname;
@property (nonatomic,copy)   NSString *kidneyname;
@property (nonatomic,copy)   NSString *adress;
@property (nonatomic,copy)   NSString *Photo;
@property (nonatomic,copy)   NSString *Age;
@property (nonatomic,copy)   NSString *TouristID;
@property (nonatomic,copy)   NSString *Telephone;
@property (nonatomic,copy)   NSString *creatDate;
@property (nonatomic,strong)  UserPictureVo *UserPictureVo;

@property(nonatomic,strong)  NSArray *picList;



@end
