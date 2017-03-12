//
//  VideoDetailsViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"
#import "Home_VideoListResult.h"
#import "SceVideoModel.h"
#import "PersonalList.h"
#import "JiangTextView.h"
#import "Friends.h"
@interface VideoDetailsViewController : BaseNavViewController
@property (nonatomic, strong) Home_VideoListResult *listResult;
@property (nonatomic, strong) PersonalList *personalList;
@property (nonatomic, strong) SceVideoModel *sceVideo;
@property (nonatomic, strong) Friends *friends;
@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, strong) JiangTextView *jiangTextView;

@end
