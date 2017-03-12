//
//  JiangTextView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MaxTextViewHeight 80 //限制文字输入的高度
@interface JiangTextView : UIView
//------ 发送文本 -----//
@property (nonatomic,copy) void (^JiangTextViewBlock)(NSString *text);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;
- (void)textViewBecomeFirstResponder:(BOOL) isBecome;
@end
