//
//  SignatureViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()
<
UITextViewDelegate
>
{
    //备注文本View高度
    float noteTextHeight;
    int count;
    
    float pickerViewHeight;
    float allViewHeight;
    
}
@property (strong, nonatomic) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;
//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;
@property (nonatomic, copy) NSString *signatureNew;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"修改签名"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.dk_backgroundColorPicker =  DKColorPickerWithColors([UIColor whiteColor], JYXColor(30, 30, 30, 1));
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:_scrollView];
    [self initViews];
    // Do any additional setup after loading the view.
}
- (void)initViews {
    self.noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);
    
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);

    _noteTextView.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    _noteTextView.text = _signature;
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    
    self.textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);

    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    _textNumberLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor]);

    _textNumberLabel.text = @"80/80    ";
    
    
    
     self.explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"2-80个字符,可由中英文,数字,'_','-'组成";
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_noteTextBackgroudView];
    [_scrollView addSubview:_noteTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:_explainLabel];
    [_scrollView addSubview:_submitBtn];
    [self updateViewsFrame];

}
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREEN_WIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, noteTextHeight);
    
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREEN_WIDTH-10, 15);
    
    
 
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, _textNumberLabel.y + _textNumberLabel.height + 10, SCREEN_WIDTH, 20);
    
    
    //提交按钮
    //    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y + _explainLabel.frame.size.height + 30, SCREEN_WIDTH - 20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y + _explainLabel.frame.size.height + 30, SCREEN_WIDTH - 20, 40);
    
    
    allViewHeight = noteTextHeight + 30 + 100;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 中文算两字符时用这个方法
    //    int length = [self convertToInt:textView.text];
    
    NSInteger length = textView.text.length;
    if (length >= 80) {
        _textNumberLabel.text = @"0/80    ";
        _textNumberLabel.textColor = [UIColor redColor];
    } else {
        _textNumberLabel.text = [NSString stringWithFormat:@"%ld/80    ", 80 - length];
        _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    }
    
    if (textView == self.noteTextView) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && text.length == 0) {
            return YES;
        }
        //so easy
        else if (textView.text.length >= 80) {
            textView.text = [textView.text substringToIndex:80];
            return NO;
        }
    }
    
    [self textChanged];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    // 中文算两字符时用这个方法
    //    int length = [self convertToInt:textView.text];
    NSInteger length = textView.text.length;
    
    if (length >= 80) {
        _textNumberLabel.text = @"0/80    ";
        
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.text = [NSString stringWithFormat:@"%ld/80    ", 80 - length];
        _textNumberLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(153, 153, 153, 1), [UIColor whiteColor]);
    }
    self.signatureNew = textView.text;
    [self textChanged];
}
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height = size.height + 10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

- (void)submitBtnClicked{
    
    if (![self checkInput]) {
        return;
    }
    [self.delegate getSignature:_signatureNew];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_noteTextView.text.length == 0) {
        //MBhudText(self.view, @"请添加记录备注", 1);
        [MBProgressHUD showTipMessageInWindow:@"签名不能为空!"];
        return NO;
    }
    return YES;
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_noteTextView resignFirstResponder];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
