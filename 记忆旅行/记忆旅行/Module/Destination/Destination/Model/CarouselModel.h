//
//  CarouselModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface CarouselModel : BaseModel
@property (nonatomic,copy)   NSString *creatDate;
@property (nonatomic,copy)   NSString *showIndex;
@property(nonatomic,strong)  NSArray *allSceID;
@property (nonatomic,copy)   NSString *ctype;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *picUrl;
@property (nonatomic,copy)   NSString *typePicUrl;
@property (nonatomic,copy)   NSString *iseffect;
@property (nonatomic,copy)   NSString *clickNum;
@property (nonatomic,copy)   NSString *modifyDate;
@property (nonatomic,copy)   NSString *shareNum;
@property (nonatomic,copy)   NSString *subjectType;
@property (nonatomic,copy)   NSString *titleName;
@property (nonatomic,copy)   NSString *remark;
@property (nonatomic,copy)   NSString *reviews;
@property (nonatomic,copy)   NSString *httpUrl;
@end
