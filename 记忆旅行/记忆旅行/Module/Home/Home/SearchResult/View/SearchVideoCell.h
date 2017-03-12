//
//  SearchVideoCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/2.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceVideoModel.h"
@protocol SearchVideoCellDelegate <NSObject>

-(void)ClickSearchHeadImageViewPushToPersonalVCWithArray:(NSMutableArray*)array type:(NSString*)type;
@end
@interface SearchVideoCell : UITableViewCell
@property (nonatomic, weak) id<SearchVideoCellDelegate> delegate;
@property (nonatomic, strong) SceVideoModel *sceVideo;
@end
