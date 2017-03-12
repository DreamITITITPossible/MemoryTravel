//
//  AlbumView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumDelegate <NSObject>

- (void)saveImage:(UIImage *)image ImageURL:(NSString *)imageURL;

@end

@interface AlbumView : UIView
@property (nonatomic, retain) NSArray *imageArray;
@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, weak) id<AlbumDelegate> delegate;
@end
