//
//  VideoDetailsViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "VideoDetailsViewController.h"
#import "VideoDetailsTableViewCell.h"
#import "CommentsCell.h"
#import "Comments.h"
#import "CommentsContent.h"
#import "XLVideoPlayer.h"
#import "JiangTextView.h"
#import "PersonalHomepageViewController.h"
#import "PicDetailsTableViewCell.h"
#import "PopMenuView.h"
#import "PicList.h"
@interface VideoDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
DetaislTableViewCellDelegate,
PicDetaislTableViewCellDelegate,
CommentsCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isAttention) BOOL isAttention;
@property (nonatomic, strong) Comments *comments;
@property (nonatomic, strong) NSMutableArray *commentsArr;
@property (nonatomic, strong) XLVideoPlayer *player;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) CommentsContent *selectedContent;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, copy) NSString *currentVideoID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isVote;
@end

@implementation VideoDetailsViewController
{
    NSString *_touristID;
    NSString *_createDate;
    NSString *_videoName;
    NSString *_videoWeight;
    NSString *_videoHeight;
    NSString *_videoPath;
    NSString *_videoURL;
    NSString *_imageURL;
    NSString *_shortImageURL;
    NSString *_nickName;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
    _isComment = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"详情"];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *moreItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_more" HighLightedImageName:@"nav_more" Size:CGSizeMake(21, 21) targetBlock:^{
        
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        
        UIAlertController *nickNameAlertController = [UIAlertController alertControllerWithTitle:@"是否举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       
        UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark - 判断是否举报过
            NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
            NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/common?&cmd=getReportTrue&resourceID=%@", _currentVideoID]];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                if ([[result objectForKey:@"flag"] isEqual:@1]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请勿重复举报" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                     NSString *urlStr1 = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/common?&cmd=addReport&resourceID=%@&type=2", _currentVideoID]];
                    HttpClient *httpClient1 = [[HttpClient alloc] init];
                    [httpClient1 GET:urlStr1 body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                        if ([[result objectForKey:@"flag"] isEqual:@1]) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"举报成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:okAction];
                            [self presentViewController:alert animated:YES completion:nil];
  
                        }
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];

                }
                
            } failure:^(NSError *error) {
                
            }];

                   }];
        

        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [nickNameAlertController addAction:reportAction];
        [nickNameAlertController addAction:cancleAction];
        [self presentViewController:nickNameAlertController animated:true completion:nil];
        } else {
            [self showAlertActionLogin];
        }
    }];
    
    self.navigationItem.rightBarButtonItem = moreItem;
    // Do any additional setup after loading the view.
    [self createBottomButtons];
    [self initData];
    [self pageViewData];
    [self getCommentsData];
    [self judgeData];
    [self createTableView];
  
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isComment == YES) {
        [self CommentAction];
    }
}
- (void)initData {
    self.commentsArr = [NSMutableArray array];
    _page = 1;
}
- (void)getCommentsData {
    NSString *typeStr;
    if ([_type isEqualToString:@"0"]) {
        typeStr = @"video";
    } else {
        typeStr = @"picture";
    }
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/comment?&page=%ld&indexID=video@%@@0&row=20&cmd=read&type=%@&lastcommid=0", _page, _currentVideoID, typeStr]];
    
    [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:nil isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_isUpdate == YES) {
            [_commentsArr removeAllObjects];
            _tableView.mj_footer.state = MJRefreshStateIdle;
            _isUpdate = NO;
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.comments = [Comments mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            
            for (CommentsContent *content in _comments.content) {
                [_commentsArr addObject:content];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_footer endRefreshing];
                if (_commentsArr.count % 20 != 0 || _commentsArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        

    } readCachesIfFailed:^(id responseObject) {
        if (_isUpdate == YES) {
            [_commentsArr removeAllObjects];
            _tableView.mj_footer.state = MJRefreshStateIdle;
            _isUpdate = NO;
        }
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.comments = [Comments mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            
            for (CommentsContent *content in _comments.content) {
                [_commentsArr addObject:content];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_footer endRefreshing];
                if (_commentsArr.count % 20 != 0 || _commentsArr.count == 0) {
                    
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        

        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
    
    
    
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
//        if (_isUpdate == YES) {
//            [_commentsArr removeAllObjects];
//            _tableView.mj_footer.state = MJRefreshStateIdle;
//            _isUpdate = NO;
//        }
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.comments = [Comments mj_objectWithKeyValues:[result objectForKey:@"result"]];
//            
//            for (CommentsContent *content in _comments.content) {
//                [_commentsArr addObject:content];
//            }
//    
//         
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.tableView.mj_footer endRefreshing];
//                if (_commentsArr.count % 20 != 0 || _commentsArr.count == 0) {
//                    
//                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//            });
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
}
- (void)pageViewData{
    User *user = [User getUserInfo];
      NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/userinfo?&id=%@&num=1&cmd=addUserVideoAndPicNum&type=1", _currentVideoID]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSLog(@"浏览量+1");
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    NSString *videourlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=getattentionVideoTrue&videoID=%@", _currentVideoID]];
    HttpClient *httpClient1 = [[HttpClient alloc] init];
    [httpClient1 GET:videourlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
           
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)judgeData {
    User *user = [User getUserInfo];
    NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
#pragma mark - 是否喜欢
    if ([_type isEqualToString:@"0"]) {
        
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=getVoteVideoTrue&videoID=%@", _currentVideoID]];
        [JYXNetworkingTool getWithUrl:urlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                self.likeBtn.selected = YES;
            } else {
                self.likeBtn.selected = NO;
            }

            
        } readCachesIfFailed:^(id responseObject) {
            if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
                self.likeBtn.selected = YES;
            } else {
                self.likeBtn.selected = NO;
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
//    HttpClient *httpClient = [[HttpClient alloc] init];
//    [httpClient GET:urlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.likeBtn.selected = YES;
//        } else {
//            self.likeBtn.selected = NO;
//        }
//     
//    } failure:^(NSError *error) {
//        
//        
//    }];
    } else {
        if (_isVote) {
            self.likeBtn.selected = YES;
        } else {
            self.likeBtn.selected = NO;
        }

    }
#pragma mark - 是否收藏
    
    NSString *collectionUrlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=getCollectVideoTrue&videoID=%@", _currentVideoID]];
    [JYXNetworkingTool getWithUrl:collectionUrlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.collectionBtn.selected = YES;
        } else {
            self.collectionBtn.selected = NO;
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.collectionBtn.selected = YES;
        } else {
            self.collectionBtn.selected = NO;
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];

//    HttpClient *collectionHttpClient = [[HttpClient alloc] init];
//    [collectionHttpClient GET:collectionUrlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.collectionBtn.selected = YES;
//        } else {
//            self.collectionBtn.selected = NO;
//        }
//
//    } failure:^(NSError *error) {
//        
//        
//    }];
#pragma mark - 是否关注
    
    NSString *attentionUrlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/userinfo?&cmd=hf&tid=%@", _touristID]];
    [JYXNetworkingTool getWithUrl:attentionUrlStr params:nil headerFile:dict isReadCache:YES isShowHub:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.isAttention = YES;
        } else {
            self.isAttention = NO;
        }
        
    } readCachesIfFailed:^(id responseObject) {
        if ([[responseObject objectForKey:@"flag"] isEqual:@1]) {
            self.isAttention = YES;
        } else {
            self.isAttention = NO;
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
//    HttpClient *attentionHttpClient = [[HttpClient alloc] init];
//    [attentionHttpClient GET:attentionUrlStr body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
//        if ([[result objectForKey:@"flag"] isEqual:@1]) {
//            self.isAttention = YES;
//        } else {
//            self.isAttention = NO;
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
}
- (void)createBottomButtons {
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - 50, SCREEN_WIDTH / 4, 50);
    _collectionBtn.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(240, 240, 240, 1), JYXColor(30, 30, 30, 1));
    [_collectionBtn setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_collectionBtn setImage:[UIImage imageNamed:@"icon_collection_null"] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"icon_collection_full"] forState:UIControlStateSelected];
    _collectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:_collectionBtn];
    
    
    [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectionBtn setTitle:@"收藏" forState:UIControlStateSelected];
    
   
    
    
    [_collectionBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        
        User *user = [User getUserInfo];
        NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
        if (user.isLogin == YES) {
#pragma mark - 收藏
            if (_collectionBtn.selected == 0) {
                
                NSString *urlString;
                NSDate *createdDate = [NSDate dateWithString:_createDate format:@"yyyy-MM-dd HH:mm:ss"];
                if ([_type isEqualToString:@"0"]) {
                    ;
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=addVideoCollectLog&videoID=%@&videoDate=%.f", _currentVideoID, [createdDate timeIntervalSince1970] * 1000];
                } else {
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&videoDate=%.f&cmd=addVideoCollectLog&type=%@&videoID=%@", [createdDate timeIntervalSince1970] * 1000, _type, _currentVideoID];
                }
                
                HttpClient *httpClient = [[HttpClient alloc] init];
               [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        _collectionBtn.selected = !_collectionBtn.selected;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消收藏
                NSString *urlString;
                if ([_type isEqualToString:@"0"]) {
                    ;
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=delVideoCollectLog&id=%@", _currentVideoID];
                } else {
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=delVideoCollectLog&id=%@&type=%@", _currentVideoID, _type];
                }
                
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {

                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        _collectionBtn.selected = !_collectionBtn.selected;
                        
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self showAlertActionLogin];
        }
        
    }];

    CGSize collectionimageSize = _collectionBtn.imageView.frame.size;
    _collectionBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - collectionimageSize.width / 10);
    CGSize collectiontitleSize = _collectionBtn.titleLabel.frame.size;
    _collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - collectiontitleSize.width / 10, 0.0, 0.0);
    
    
    
    
    
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(240, 240, 240, 1), JYXColor(30, 30, 30, 1));
    
    _likeBtn.frame = CGRectMake(SCREEN_WIDTH / 4 * 1, SCREEN_HEIGHT - 64 - 50, SCREEN_WIDTH / 4, 50);
    
    [_likeBtn setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_likeBtn setImage:[UIImage imageNamed:@"icon_like_null"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"icon_like_full"] forState:UIControlStateSelected];
    _likeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:_likeBtn];
    
    
    [_likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    [_likeBtn setTitle:@"喜欢" forState:UIControlStateSelected];
    
    
   
    
    
    [_likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        
        User *user = [User getUserInfo];
        NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
        if (user.isLogin == YES) {
#pragma mark - 点赞
            if (_likeBtn.selected == 0) {
                NSString *urlString;
                if ([_type isEqualToString:@"0"]) {
               urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=VoteLCVideo&num=1&id=%@", _currentVideoID];
                } else {
                urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=1&cmd=addUserVideoAndPicNum&type=0", _currentVideoID];
                }
            

                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        _likeBtn.selected = !_likeBtn.selected;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消点赞
                NSString *urlString;
                if ([_type isEqualToString:@"0"]) {
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/livideo?&cmd=cancelVideoVote&videoID=%@", _currentVideoID];
                } else {
                    urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=-1&cmd=addUserVideoAndPicNum&type=0", _currentVideoID];
                }
               
                HttpClient *httpClient = [[HttpClient alloc] init];
               [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                   NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        _likeBtn.selected = !_likeBtn.selected;
                        
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self showAlertActionLogin];
        }
        
    }];
    CGSize likeimageSize = _likeBtn.imageView.frame.size;
    _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - likeimageSize.width / 10);
    CGSize liketitleSize = _likeBtn.titleLabel.frame.size;
    _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - liketitleSize.width / 10, 0.0, 0.0);
    

    
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(240, 240, 240, 1), JYXColor(30, 30, 30, 1));

    
    [shareBtn setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:shareBtn];
   
    
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//    }];

    
    [shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            User *user = [User getUserInfo];
            if (user.isLogin) {
                
//                
//                    NSArray *imageArray = @[@"sns_icon_22", @"sdk_weibo_logo"];
//                    PopMenuView *popMenuView = [[PopMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ImageArray:imageArray didShareButtonBlock:^(NSInteger tag) {
//                        if (tag == 0) {
//                           
//                        }
//                    }];
//                    
//                    [popMenuView show];
//
                [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];

                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    UMSocialMessageObject *messageObject =   [UMSocialMessageObject messageObject];
                    messageObject.title = @"Test";
                    messageObject.text = @"这是一条测试信息";
                    UMShareWebpageObject *webpageObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"记忆旅行 | %@", _videoName] descr:_nickName thumImage:[UIImage getImageFromURL:_imageURL]];
                    if ([_type isEqualToString:@"0"]) {
                        webpageObject.webpageUrl = [NSString stringWithFormat:@"http://www.51laiya.com/manager/app.php?m=app&c=video&a=index&id=%@&from=timeline&isappinstalled=1", _currentVideoID];
                     
                    } else {
                        webpageObject.webpageUrl = [NSString stringWithFormat:@"http://www.51laiya.com/operate/App/tourpic.html?id=%@&from=timeline&isappinstalled=1", _currentVideoID];
                    }
                    messageObject.shareObject = webpageObject;
                 
                    
                    // 根据获取的platformType确定所选平台进行下一步操作
                    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                        NSLog(@"%@", result);

                        NSLog(@"%@", error);
                        
                    }];
                }];
            } else {
                [self showAlertActionLogin];
            }

    }];
    shareBtn.frame = CGRectMake(SCREEN_WIDTH / 4 * 2, SCREEN_HEIGHT - 64 - 50, SCREEN_WIDTH / 4, 50);
    CGSize shareimageSize = shareBtn.imageView.frame.size;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - shareimageSize.width / 10);
    CGSize sharetitleSize = shareBtn.titleLabel.frame.size;
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - sharetitleSize.width / 10, 0.0, 0.0);

    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BTNGREENBG);
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [commentBtn setImage:[UIImage imageNamed:@"icon_comments_white"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:commentBtn];
    
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    
    __weak typeof(self) weakSelf = self;
    [commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
      
        if (user.isLogin == YES) {
            [weakSelf CommentAction];
        } else {
            
            [self showAlertActionLogin];
        }

        
    }];

    commentBtn.frame = CGRectMake(SCREEN_WIDTH / 4 * 3, SCREEN_HEIGHT - 64 - 50, SCREEN_WIDTH / 4, 50);
    CGSize commentimageSize = commentBtn.imageView.frame.size;
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - commentimageSize.width / 10);
    CGSize commenttitleSize = commentBtn.titleLabel.frame.size;
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - commenttitleSize.width / 10, 0.0, 0.0);
    

 
    
    
}
- (void)CommentAction{
    __weak typeof(self) weakSelf = self;
    _isComment = NO;
    NSString *typeStr;
    if ([_type isEqualToString:@"0"]) {
        typeStr = @"video";
    } else {
        typeStr = @"picture";
    }
    UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
        [weakSelf.view addSubview:weakSelf.jiangTextView];
        weakSelf.selectedContent = nil;
        [weakSelf.jiangTextView textViewBecomeFirstResponder:YES];
        
        weakSelf.jiangTextView.JiangTextViewBlock = ^(NSString *test){
            NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/comment?&indexID=video@%@@0&userid=%@&comment=%@&cmd=write&type=%@&commid=%@", weakSelf.currentVideoID, userInfo.TEL,test, typeStr, weakSelf.selectedContent.userID]];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                if ([[result objectForKey:@"flag"] isEqual:@1]) {
                    NSLog(@"%@", [result objectForKey:@"result"]);
                    _isUpdate = YES;
                    [self getCommentsData];
                }
                
            } failure:^(NSError *error) {
                
                
            }];
            
        };
        
        

}
#pragma mark - 协议
- (void)presentPicDetailsToLoginVCIfNot {
    [self showAlertActionLogin];
}

- (void)presentVideoDetailsToLoginVCIfNot {
    [self showAlertActionLogin];

}
- (void)detailsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial {
    PersonalHomepageViewController *personalHomePageVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    personalHomePageVC.touristID = touristID;
    [self.navigationController pushViewController:personalHomePageVC animated:YES];
}
- (void)picDetailsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial {
    PersonalHomepageViewController *personalHomePageVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    personalHomePageVC.touristID = touristID;
    [self.navigationController pushViewController:personalHomePageVC animated:YES];
}
- (void)CommentsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial {
    PersonalHomepageViewController *personalHomePageVC = [[PersonalHomepageViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    personalHomePageVC.touristID = touristID;
    [self.navigationController pushViewController:personalHomePageVC animated:YES];
}
- (void)presentDetailsVideoToLoginVCIfNot {
    [self showAlertActionLogin];
}
- (void)presentDetailsPicToLoginVCIfNot {
    [self showAlertActionLogin];
}
- (JiangTextView *)jiangTextView {
    if (!_jiangTextView) {
        _jiangTextView = [[JiangTextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 49, SCREEN_WIDTH, 0)];
        _jiangTextView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_jiangTextView setPlaceholderText:@"请输入文字"];
       
    }
    return _jiangTextView;
}

- (void)setIsComment:(BOOL)isComment {
    if (_isComment != isComment) {
        _isComment  = isComment;
    }
  
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 12345;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors(JYXColor(230,230,230,1), [UIColor blackColor]);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    [self.view addSubview:_tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = _page + 1;
        [self getCommentsData];
    }];

}
- (void)setListResult:(Home_VideoListResult *)listResult {
    if (_listResult != listResult) {
        _listResult = listResult;
    }
    _type = @"0";
    _isVote = listResult.isVote;
    _currentVideoID = listResult.ID;
    _createDate = listResult.creatDate;
    _touristID = listResult.TouristID;
    _videoName = listResult.videoName;
    _videoWeight = listResult.videoWidth;
    _videoHeight = listResult.videoHeight;
    _videoPath = listResult.videoPath;
    _nickName = listResult.Nickname;
    _videoURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _videoPath];
    
    _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, listResult.videoPic];
    
}
- (void)setFriends:(Friends *)friends {
    if (_friends != friends) {
        _friends = friends;
    }
    _isVote = friends.vo.isVote;

    _type = friends.type;
    _currentVideoID = friends.vo.ID;
    _createDate = friends.vo.creatDate;
    _touristID = friends.vo.TouristID;
    _videoWeight = friends.vo.videoWidth;
    _videoHeight = friends.vo.videoHeight;
    _videoPath = friends.vo.videoPath;
    _nickName = friends.vo.Nickname;
    _videoURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _videoPath];
    if ([_type isEqualToString:@"0"]) {
        _videoName = friends.vo.videoName;

        _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.videoPic];
    } else {
        _videoName = friends.vo.title;

        PicList *picObject = friends.vo.picList.firstObject;
         _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, picObject.picURL];
    }

}
- (void)setPersonalList:(PersonalList *)personalList {
    if (_personalList != personalList) {
        _personalList = personalList;
    }
    _isVote = personalList.vo.isVote;

    _type = personalList.type;
    if ([personalList.type isEqualToString:@"1"]) {
        _currentVideoID = personalList.vo.UserPictureVo.ID;
        _videoName = personalList.vo.UserPictureVo.title;

    } else {
    _currentVideoID = personalList.vo.cameraVideoVo.ID;
        _videoName = personalList.vo.cameraVideoVo.videoName;

    }
    _createDate = personalList.vo.creatDate;
    _touristID = personalList.vo.TouristID;
    
    _videoWeight = personalList.vo.cameraVideoVo.videoWidth;
    _videoHeight = personalList.vo.cameraVideoVo.videoHeight;
    _videoPath = personalList.vo.cameraVideoVo.videoPath;
    _nickName = personalList.vo.Nickname;
    _videoURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _videoPath];
    if ([_type isEqualToString:@"0"]) {
        
        _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, personalList.vo.cameraVideoVo.videoPic];
    } else {
        PicList *picObject = personalList.vo.UserPictureVo.picList.firstObject;
        _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, picObject.picURL];
    }
}
- (void)setSceVideo:(SceVideoModel *)sceVideo {
    if (_sceVideo != sceVideo) {
        _sceVideo = sceVideo;
    }
    _isVote = sceVideo.isVote;

    _type = @"0";
    _currentVideoID = sceVideo.ID;
    _createDate = sceVideo.creatDate;
    _touristID = sceVideo.TouristID;
    _videoName = sceVideo.videoName;
    _videoWeight = sceVideo.videoWidth;
    _videoHeight = sceVideo.videoHeight;
    _videoPath = sceVideo.videoPath;
    _nickName = sceVideo.Nickname;
    _videoURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _videoPath];
    _imageURL = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.videoPic];
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (1 == section) {
        return _commentsArr.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        CGFloat titleHight;
        if ([_friends.type integerValue] == 1 || [_personalList.vo.type integerValue] == 1)  {
            CGFloat height;
            NSInteger count;
            if (_friends) {
              count = _friends.vo.picList.count;
                titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_friends.vo.title font:[UIFont systemFontOfSize:16]];
            } else {
                titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_personalList.vo.UserPictureVo.title font:kFONT_SIZE_18];
                 count = _personalList.vo.UserPictureVo.picList.count;
            }
           
            CGFloat picHeight;
            if (count < 4) {
                picHeight = (SCREEN_WIDTH - 30) / 3;
            } else if (count >= 4 && count < 7) {
                picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
            } else {
                picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
            }
            
            height = 10 + 40 + 10 + titleHight + 10 + picHeight + 10;
            return height;
            
        } else {
        CGFloat height;
        CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_videoName font:kFONT_SIZE_18];
        CGFloat videoH;
        if ([_videoWeight integerValue] < [_videoHeight integerValue]) {
            videoH = 360;
        } else  {
            videoH = (SCREEN_WIDTH - 40) * 9 / 16;
        }
        height = 10 + 40 + 10 + titleHight + 10 + videoH + 10;
        return height;
        }
    }
    
    CommentsContent *content = _commentsArr[indexPath.row];
    CGFloat commentHeight;
    NSString *commentStr;
    CGFloat labelHeight;
    if (content.pidNickname.length > 0) {
      commentStr  = [NSString stringWithFormat:@"回复@%@:%@", content.pidNickname, content.comment];
        NSString *str = [NSString stringWithFormat:@"引用@%@:%@", content.pidNickname, content.pidComment];
        labelHeight = [UILabel getHeightByWidth:SCREEN_WIDTH - 20 - 30 - 10 - 20 - 16 title:str font:[UIFont systemFontOfSize:17]] + 10;
    } else {
        commentStr = content.comment;
        labelHeight = 0;
    }
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 20 - 30 - 10 - 30) title:commentStr font:[UIFont systemFontOfSize:17]];
   

    
    commentHeight = 10  + 30 - 5 + titleHight + 5 + labelHeight + 10;
    
    
    
    
    return commentHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([_friends.type integerValue] == 1 || [_personalList.vo.type integerValue] == 1) {
            static   NSString *const picDetailsIdentifier = @"picDetailsIdentifier";
            PicDetailsTableViewCell *picDetailsCell = [tableView dequeueReusableCellWithIdentifier:picDetailsIdentifier];
            if (!picDetailsCell) {
                picDetailsCell = [[PicDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:picDetailsIdentifier];
            }
            if (_friends) {
                
                picDetailsCell.friends = _friends;;
            } else {
                
                picDetailsCell.personalList = _personalList;
            }
            picDetailsCell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

            picDetailsCell.delegate = self;
            picDetailsCell.isAttention = _isAttention;
            picDetailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return picDetailsCell;

        } else {
     static   NSString *const detailsIdentifier = @"detailsIdentifier";
        VideoDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:detailsIdentifier];
        if (!detailsCell) {
            detailsCell = [[VideoDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:detailsIdentifier];
        }
        if (_listResult) {
            
            detailsCell.homeListResult = _listResult;
        } else if (_personalList){
            
            detailsCell.personalList = _personalList;
        } else if (_sceVideo){
            detailsCell.sceVideo = _sceVideo;
        } else {
            detailsCell.friends = _friends;
        }
        detailsCell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        detailsCell.delegate = self;
        detailsCell.isAttention = _isAttention;
        detailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
        [detailsCell.videoBackImgBlurView addGestureRecognizer:tap];
        
        
        return detailsCell;
        }
    }
    
    
    
  static  NSString *const commentsIdentifier = @"commentsIdentifier%ld%ld";
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsIdentifier];
    if (!cell) {
        cell = [[CommentsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commentsIdentifier];
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentsContent *content = _commentsArr[indexPath.row];
    cell.content = content;
    cell.delegate = self;
    return cell;
        
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *typeStr;
        if ([_type isEqualToString:@"0"]) {
            typeStr = @"video";
        } else {
            typeStr = @"picture";
        }

        UserInfo *userInfo = [UserInfo getUserDetailsInfomation];
        CommentsContent *content = _commentsArr[indexPath.row];
        [_jiangTextView setPlaceholderText:[NSString stringWithFormat:@"%@", content.Nickname]];
        [self.view addSubview:self.jiangTextView];
        self.selectedContent = content;
        [self.jiangTextView textViewBecomeFirstResponder:YES];
        __weak typeof(self) weakSelf = self;
        self.jiangTextView.JiangTextViewBlock = ^(NSString *test){
            NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/comment?&indexID=video@%@@0&userid=%@&comment=%@&cmd=write&type=%@&commid=%@", weakSelf.currentVideoID, userInfo.TEL, test, typeStr,content.commid]];
            HttpClient *httpClient = [[HttpClient alloc] init];
            [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                if ([[result objectForKey:@"flag"] isEqual:@1]) {
                    _isUpdate = YES;
                    [weakSelf getCommentsData];
                }
                
            } failure:^(NSError *error) {
                
                
            }];
            
        };
    }
}
#pragma mark - 手势动作 显示播放器
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    UITableView *currentTableView = [self.view viewWithTag:12345];
    UIView *view = tapGesture.view;
    
    NSIndexPath *_indexPath;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    VideoDetailsTableViewCell *cell = [currentTableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = [NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _videoPath];
    [_player playerBindTableView:currentTableView currentIndexPath:_indexPath];
    _player.frame = view.frame;
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        _player = nil;
    };
#pragma mark - 播放次数+1
    NSString *urlStr = [baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/livideo?&cmd=ReviewsLCVideo&id=%@&num=1", _currentVideoID]];
    HttpClient *httpClient = [[HttpClient alloc] init];
    [httpClient GET:urlStr body:nil headerFile:nil response:JYX_JSON isShowHub:NO success:^(id result) {
        if ([[result objectForKey:@"flag"] isEqual:@1]) {
            NSLog(@"播放次数+1");
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:NO];
    }
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
