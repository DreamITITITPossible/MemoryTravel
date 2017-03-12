//
//  UIViewController+SelectPhotoIcon.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SelectPhotoIcon)
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate
>


- (UIImagePickerController *)imagePickerController;
/**
 *  调用相册
 */
- (void)showActionSheet;
- (void)useCamera;
- (void)usePhoto;




@end
