//
//  AlbumViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"

@interface AlbumViewController : BaseNavViewController
@property (nonatomic, retain) NSArray *albumArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *name;
@end
