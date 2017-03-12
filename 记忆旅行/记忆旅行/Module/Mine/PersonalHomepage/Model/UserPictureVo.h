//
//  UserPictureVo.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface UserPictureVo : BaseModel


@property (nonatomic,copy)   NSString *collectNum;
@property (nonatomic,copy)   NSString *sharNum;
@property (nonatomic,copy)   NSString *maplat;
@property (nonatomic,copy)   NSString *modifyDate;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *isshow;
@property (nonatomic,copy)   NSString *dummyreviews;
@property (nonatomic,copy)   NSString *userID;
@property (nonatomic,copy)   NSString *lon;
@property (nonatomic,copy)   NSString *score;
@property(nonatomic,strong)  NSArray *picList;
@property (nonatomic,copy)   NSString *dummyscore;
@property (nonatomic,copy)   NSString *sceName;
@property (nonatomic,copy)   NSString *reviews;
@property (nonatomic,copy)   NSString *frameState;
@property (nonatomic,copy)   NSString *dr;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *sceAttentionNum;
@property (nonatomic,copy)   NSString *maplon;
@property (nonatomic,copy)   NSString *adress;
@property (nonatomic,copy)   NSString *vote;
@property (nonatomic,copy)   NSString *lat;
@property (nonatomic,copy)   NSString *commens;
@property (nonatomic,copy)   NSString *cityID;
@property (nonatomic,copy)   NSString *creatDate;
@property (nonatomic,copy)   NSString *showIndex;

@end
