//
//  NSNumber+Extend.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]


@interface NSNumber (Extend)

- (double)safeDouble;
- (BOOL)numberIsFloat;
- (BOOL)numberIsInt;

@end
