//
//  ScePhotoCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScePhotoModel.h"
@interface ScePhotoCell : UICollectionViewCell
@property (nonatomic, strong) ScePhotoModel *scePhoto;
@property (nonatomic, retain) UIImage *image;

@end
