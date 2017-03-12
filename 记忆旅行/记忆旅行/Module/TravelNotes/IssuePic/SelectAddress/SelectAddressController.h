//
//  SelectAddressController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectAddressControllerDelegate <NSObject>

- (void)selectAddressName:(NSString *)addressName;

@end
@interface SelectAddressController : BaseViewController
@property (nonatomic, strong) NSMutableArray *searchAddressArr;
@property (nonatomic, weak) id<SelectAddressControllerDelegate> delegate;
@end
