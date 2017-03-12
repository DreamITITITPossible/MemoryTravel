//
//  AlbumViewController.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumView.h"
@interface AlbumViewController ()
<
AlbumDelegate
>

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:@"相册"];;
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    //    self.tabBarController.tabBar.hidden = YES;
    
    AlbumView *albumView = [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    albumView.delegate = self;
    albumView.imageArray = _albumArray;
    albumView.currentNum = _currentIndex;
    //    albumView.center = self.view.center;
    [self.view addSubview:albumView];
    
}
- (void)saveImage:(UIImage *)image ImageURL:(NSString *)imageURL{
    UIAlertController *nickNameAlertController = [UIAlertController alertControllerWithTitle:_name message:@"请选择您所需的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:@"保存图片"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制图片地址"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = imageURL;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拷贝成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
          }];
    
       UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [nickNameAlertController addAction:saveImageAction];
    [nickNameAlertController addAction:copyAction];
    [nickNameAlertController addAction:cancleAction];
    [self presentViewController:nickNameAlertController animated:true completion:nil];

    
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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
