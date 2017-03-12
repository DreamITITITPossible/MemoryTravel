//
//  CommentsCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsContent.h"
@protocol CommentsCellDelegate <NSObject>

- (void)CommentsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial;

@end


@interface CommentsCell : UITableViewCell
@property (nonatomic, strong) CommentsContent *content;
@property (nonatomic, weak) id<CommentsCellDelegate> delegate;
@end
