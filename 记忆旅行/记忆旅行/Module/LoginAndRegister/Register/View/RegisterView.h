//
//  RegisterView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "BaseView.h"
@protocol RegisterViewDelegate <NSObject>

- (void)getVerifyCode: (NSInteger)tag;
- (void)nextStep: (NSInteger)tag;
@end
@interface RegisterView : BaseView

@property (nonatomic, assign) id<RegisterViewDelegate>delegate;

@property (nonatomic, copy) NSString *telephoneText;
@property (nonatomic, copy) NSString *verifyCodeText;
@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, copy) NSString *passwordText;
- (void)startTime;


@end
