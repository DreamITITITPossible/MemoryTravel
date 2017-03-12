//
//  DateTimePickerView.h
//  FindTraining
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Yuxiao Jiang. All rights reserved.
//
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (SCREEN_WIDTH / 320))

#import <UIKit/UIKit.h>
#import "JiangCycleScrollView.h"

typedef enum {
    DatePickerDateMode,
    DatePickerTimeMode,
    DatePickerDateTimeMode,
    DatePickerYearMonthMode,
    DatePickerMonthDayMode,
    DatePickerHourMinuteMode,
    DatePickerDateHourMinuteMode
} DatePickerMode;

typedef void(^DatePickerCompleteAnimationBlock)(BOOL Complete);
typedef void(^ClickedOkBtn)(NSString *dateTimeStr);

@end
@interface DateTimePickerView : UIView
<
JiangCycleScrollViewDatasource,
JiangCycleScrollViewDelegate
>
@property (nonatomic,strong) ClickedOkBtn clickedOkBtn;

@property (nonatomic,assign) DatePickerMode datePickerMode;

@property (nonatomic,assign) NSInteger maxYear;
@property (nonatomic,assign) NSInteger minYear;

@property (nonatomic,strong) UIColor *topViewColor;
@property (nonatomic,strong) UIColor *buttonTitleColor;
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,weak  ) NSString *title;

-(instancetype)initWithDefaultDatetime:(NSDate*)dateTime;
-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode defaultDateTime:(NSDate*)dateTime;
-(void) showHcdDateTimePicker;

@end
