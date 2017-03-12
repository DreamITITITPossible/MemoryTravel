//
//  TraceModel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface TraceModel : BaseModel
@property (nonatomic,copy)   NSString *traRemark;
@property (nonatomic,copy)   NSString *traceEndTime;
@property (nonatomic,copy)   NSString *traTitlepage;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *traTheme;
@property (nonatomic,copy)   NSString *hotTem;
@property (nonatomic,copy)   NSString *traUser;
@property (nonatomic,copy)   NSString *traceDistance;
@property (nonatomic,copy)   NSString *traceStartTime;
@property (nonatomic,copy)   NSString *userPage;
@property (nonatomic,copy)   NSString *userName;
@property (nonatomic,copy)   NSString *traSite;
@property (nonatomic,copy)   NSString *traType;
@property (nonatomic,copy)   NSString *isshow;
@end
