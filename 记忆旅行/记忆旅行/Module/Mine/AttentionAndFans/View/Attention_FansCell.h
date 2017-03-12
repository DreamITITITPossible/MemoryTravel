//
//  Attention_FansCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attention_FansModel.h"

@protocol Attention_FansCellDelegate <NSObject>

- (void)presentAttention_FansToLoginIfNot;

@end
@interface Attention_FansCell : UITableViewCell
@property (nonatomic, strong) Attention_FansModel *attention_FansModel;
@property (nonatomic, weak) id<Attention_FansCellDelegate> delegate;
@end
