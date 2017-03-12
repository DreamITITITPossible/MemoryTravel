//
//  SceBtnCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceBtnCell.h"
#import "SceBtnView.h"

@interface SceBtnCell ()
<
UIWebViewDelegate,
SceBtnViewDelegate
>
@property (nonatomic, strong) UIWebView *webView;

@end
@implementation SceBtnCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *imageArray = @[@"jingdian", @"shipin", @"tupian", @"youji"];
        NSArray *titleArray = @[@"景点", @"视频", @"美图", @"游记"];
        for (int i = 0; i < 4; i++) {
            SceBtnView *scebtnView = [[SceBtnView alloc] init];
            scebtnView.tag = 1234 + i;
            scebtnView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
            scebtnView.titleName = titleArray[i];
            scebtnView.imageName = imageArray[i];
            scebtnView.index = i;
            scebtnView.delegate = self;
            [self.contentView addSubview:scebtnView];
        }
        self.webView = [[UIWebView alloc] init];
        _webView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        [self.contentView addSubview:_webView];
    }
    return self;
}
- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    NSArray *array = [_scenicSpots.allSceID componentsSeparatedByString:@"+"];
    NSString *lon = array.firstObject;
    NSString *lat = array.lastObject;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.51laiya.com/manager/app.php?m=app&c=index&a=sceindex&lon=%@&lat=%@", lon, lat]]];
    [_webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    if (_height != height) {
        self.webView.frame = CGRectMake(0, 90, SCREEN_WIDTH, height);
        
        [self.delegate getWebViewHeight:height];
    }
    
   
}
- (void)ClickBtnPushToVCWithIndex:(NSInteger)index {
    [self.delegate clickWithIndex:index];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < 4; i++) {
        SceBtnView *scebtnView = [self viewWithTag:1234 + i];
        scebtnView.frame = CGRectMake(SCREEN_WIDTH / 4 * i, 0, SCREEN_WIDTH / 4, 90);
    }
    _webView.frame = CGRectMake(0, 90, SCREEN_WIDTH, _height - 90);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
