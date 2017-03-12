//
//  SignatureViewController.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseNavViewController.h"
@protocol SignatureViewControllerDelegate <NSObject>

- (void)getSignature:(NSString *)signature;

@end

@interface SignatureViewController : BaseNavViewController
@property (nonatomic, weak) id<SignatureViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *signature;

@end
