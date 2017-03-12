//
//  AlbumZoomScrollView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumZoomScrollViewDelegate <NSObject>

- (void)saveToPhotoWithImage:(UIImage *)image ImageURL:(NSString *)imageURL;

@end
@interface AlbumZoomScrollView : UIScrollView
@property (nonatomic, retain) NSString *imgUrl;

@property (nonatomic, weak) id<AlbumZoomScrollViewDelegate>saveDelegate;
@end
