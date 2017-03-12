//
//  User.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "User.h"

@implementation User


+ (User *) getUserInfo {
// 单例
//    static User *user = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        
//        NSData *userData = [userDefaults objectForKey:@"userData"];
//        user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    });

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *userData = [userDefaults objectForKey:@"userData"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    return user;

}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.IMID forKey:@"IMID"];
    [aCoder encodeObject:self.JSESSIONID forKey:@"JSESSIONID"];
    [aCoder encodeObject:self.SERISE forKey:@"SERISE"];
    [aCoder encodeObject:self.SERISE forKey:@"isLogin"];

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
    self.IMID = [aDecoder decodeObjectForKey:@"IMID"];
    self.JSESSIONID = [aDecoder decodeObjectForKey:@"JSESSIONID"];
    self.SERISE = [aDecoder decodeObjectForKey:@"SERISE"];
    self.isLogin = [aDecoder decodeObjectForKey:@"isLogin"];

    }
    return self;
}
@end
