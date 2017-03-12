//
//  User.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>
@property (nonatomic, copy) NSString *JSESSIONID;
@property (nonatomic, copy) NSString *IMID;
@property (nonatomic, copy) NSString *SERISE;
@property (nonatomic, assign) BOOL isLogin;
+ (User *)getUserInfo;
@end
