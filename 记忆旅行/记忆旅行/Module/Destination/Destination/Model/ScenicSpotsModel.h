//
//  ScenicSpotsModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface ScenicSpotsModel : BaseModel
@property (nonatomic,copy)   NSString *picUrl;
@property (nonatomic,copy)   NSString *wantGo;
@property (nonatomic,assign) BOOL isLive;
@property (nonatomic,copy)   NSString *remark;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *termini;
@property (nonatomic,copy)   NSString *titleName;
@property (nonatomic,copy)   NSString *showIndex;
@property (nonatomic,copy)   NSString *allSceID;
@end
