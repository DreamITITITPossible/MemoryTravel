//
//  PicList.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseModel.h"

@interface PicList : BaseModel
@property (nonatomic,copy)   NSString *picURL;
@property (nonatomic,copy)   NSString *picWidth;
@property (nonatomic,copy)   NSString *picHeight;
@property (nonatomic,copy)   NSString *ID;
@property (nonatomic,copy)   NSString *shrotPicURL;

@end
