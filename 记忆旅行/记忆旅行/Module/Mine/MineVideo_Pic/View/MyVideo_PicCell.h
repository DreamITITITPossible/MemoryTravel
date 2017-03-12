//
//  MyVideo_PicCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceVideoModel.h"
#import "PersonalList.h"
@interface MyVideo_PicCell : UICollectionViewCell
@property (nonatomic, strong) SceVideoModel *sceVideo;
@property (nonatomic, strong) PersonalList *personalList;
@end
