//
//  ScePhotoLayout.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScePhotoLayout;
@protocol ScePhotoLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ScePhotoLayout *)layout width:(CGFloat)width heightAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface ScePhotoLayout : UICollectionViewLayout
/**
 *  提供列数
 */
@property (nonatomic, assign) NSInteger numberOfColumn;
/**
 *  提供每个item之间的间距
 */
@property (nonatomic, assign) CGFloat itemMergin;
@property (nonatomic, assign) BOOL isReset;
@property (nonatomic, assign) id<ScePhotoLayoutDelegate> delegate;
@end



