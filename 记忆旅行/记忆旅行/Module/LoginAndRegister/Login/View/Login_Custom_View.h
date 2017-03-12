//
//  Login_Custom_View.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login_Custom_View : UIView
<
UITextFieldDelegate
>
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) UIColor *textFieldColor;
@property (nonatomic, retain) UIColor *imageViewColor;
@property (nonatomic, retain) UITextField *textField;
@end
