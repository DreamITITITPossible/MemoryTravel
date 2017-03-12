//
//  ScePhotoViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SortBaseViewController.h"
#import "ScenicSpotsModel.h"

@interface ScePhotoViewController : SortBaseViewController
@property (nonatomic, strong) ScenicSpotsModel *scenicSpots;
@property (nonatomic, copy) NSString *sceName;
@end
