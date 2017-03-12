//
//  CarouselView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "CarouselView.h"
#import "ZoomScrollView.h"

@interface CarouselView ()
<
UIScrollViewDelegate
>
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *currentImageArray;
@property (nonatomic, retain) NSTimer *timer;
@end
@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentImageArray = [NSMutableArray array];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        // CGRectZero 四个值都为0;
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        // 单页时隐藏
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    [self addTimer];
    return self;
}
- (void)setBannerImageArray:(NSArray *)bannerImageArray {
    
    if (_bannerImageArray != bannerImageArray) {
        _bannerImageArray = bannerImageArray;
        
#pragma mark - 拓展 赋值了两次数组,重复创建!!!  判断是否大于0 如果是就清空
        if (_currentImageArray.count > 0) {
            [_currentImageArray removeAllObjects];
            for (UIView *subView in _scrollView.subviews) {
                if ([subView isKindOfClass:[UIScrollView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
        }
        [_currentImageArray addObject:[_bannerImageArray lastObject]];
        [_currentImageArray addObjectsFromArray:_bannerImageArray];
        [_currentImageArray addObject:[_bannerImageArray firstObject]];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _currentImageArray .count, self.bounds.size.height);
        CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_bannerImageArray.count];
        CGPoint pageControlOrigin = {(self.bounds.size.width - pageControlSize.width) / 2, self.bounds.size.height - pageControlSize.height - 5};
        CGRect pageControlFrame = {pageControlOrigin, pageControlSize};
        _pageControl.frame = pageControlFrame;
        _pageControl.numberOfPages = _bannerImageArray.count;
        _pageControl.currentPage = 0;
        for (int i = 0; i < _currentImageArray.count; i++) {
            CGPoint zoomViewOrigin = {i * self.bounds.size.width, 0};
            CGSize zoomViewSize = self.bounds.size;
            CGRect zoomViewFrame = {zoomViewOrigin, zoomViewSize};
            ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc] initWithFrame:zoomViewFrame];
            zoomScrollView.imageURL = _currentImageArray[i];
            zoomScrollView.tag = 10000 + i;
            zoomScrollView.delegate = self;
            //            zoomScrollView.maximumZoomScale = 4.0f;
            //            zoomScrollView.minimumZoomScale = 0.25f;
            [_scrollView addSubview:zoomScrollView];
            _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            
            // 设置多点轻拍
            tap.numberOfTouchesRequired = 1;
            // 视图添加一个手势
            [zoomScrollView addGestureRecognizer:tap];
            
        }
    }
    
    
}
- (void)tapAction:(UIGestureRecognizer *)tap {
    [self.delegate tapToVCAction:tap.view.tag - 10001];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger pageNumber = scrollView.contentOffset.x / scrollView.bounds.size.width;
        if (0 == pageNumber) {
            pageNumber = _bannerImageArray.count;
        } if (_bannerImageArray.count + 1 == pageNumber) {
            pageNumber = 1;
        }
        _pageControl.currentPage = pageNumber - 1;
        scrollView.contentOffset  = CGPointMake(scrollView.bounds.size.width * pageNumber, 0);
        for (UIView *subView in scrollView.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *subScroView = (UIScrollView *)subView;
                subScroView.zoomScale = 1.0f;
            }
        }
    }
}
- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    [_scrollView setContentOffset:CGPointMake((pageControl.currentPage + 1) * self.bounds.size.width, 0) animated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews firstObject];
}

#pragma mark - 拓展_缩小在中心显示
// 正在缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width <= scrollView.bounds.size.width) {
        UIImageView *imageView = [scrollView.subviews firstObject];
        imageView.center = CGPointMake(scrollView.bounds.size.width / 2, scrollView.bounds.size.height / 2);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}



// 添加定时器

- (void)addTimer {
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

// timer:下一张图片
-(void)nextImage {
    //            NSInteger pageNumber = self.pageControl.currentPage;
    //            if (pageNumber == (_bannerImageArray.count - 1)) {
    //                pageNumber = 0;
    //            }else{
    //                pageNumber++;
    //            }
    //            _scrollView.contentOffset = CGPointMake(pageNumber * SCREEN_WIDTH, 0);
    //
    
    NSInteger pageNumber = _scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (_bannerImageArray.count ==  pageNumber) {
        pageNumber = 0;
        _scrollView.contentOffset = CGPointMake(pageNumber * SCREEN_WIDTH, 0);
    }
    
    [_scrollView setContentOffset:CGPointMake((pageNumber + 1) * SCREEN_WIDTH, 0) animated:YES];
    _pageControl.currentPage = pageNumber;
    
    
}

//关闭定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    
    if ([scrollView isEqual:_scrollView]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
    
}

// 结束拖拽是调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.f]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.timer invalidate];
    
}

@end
