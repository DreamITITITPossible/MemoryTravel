//
//  UserInfo.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (UserInfo *) getUserDetailsInfomation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *userData = [userDefaults objectForKey:@"userInfoData"];
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    return user;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
   
    [aCoder encodeObject:self.QQ forKey:@"QQ"];
    [aCoder encodeObject:self.Wechat forKey:@"Wechat"];
    [aCoder encodeObject:self.Age1 forKey:@"Age1"];
    [aCoder encodeObject:self.Email forKey:@"Email"];
    [aCoder encodeObject:self.Photo forKey:@"Photo"];
    [aCoder encodeObject:self.backpic forKey:@"backpic"];
    [aCoder encodeObject:self.extr forKey:@"extr"];
    [aCoder encodeObject:self.kidneyname forKey:@"kidneyname"];
    [aCoder encodeObject:self.Address forKey:@"Address"];
    [aCoder encodeObject:self.Nickname forKey:@"Nickname"];
    [aCoder encodeObject:self.TEL forKey:@"TEL"];
    [aCoder encodeObject:self.Age forKey:@"Age"];
    [aCoder encodeObject:self.Sex forKey:@"Sex"];
    [aCoder encodeObject:self.Weibo forKey:@"Weibo"];
    [aCoder encodeObject:self.TourID forKey:@"TourID"];
    NSData *imageData=UIImagePNGRepresentation(_headImage);
    [aCoder encodeObject:imageData forKey:@"imageData"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.QQ = [aDecoder decodeObjectForKey:@"QQ"];
        self.Wechat = [aDecoder decodeObjectForKey:@"Wechat"];
        self.Age1 = [aDecoder decodeObjectForKey:@"Age1"];
        self.Email = [aDecoder decodeObjectForKey:@"Email"];
        self.Photo = [aDecoder decodeObjectForKey:@"Photo"];
        self.backpic = [aDecoder decodeObjectForKey:@"backpic"];
        self.extr = [aDecoder decodeObjectForKey:@"extr"];
        self.kidneyname = [aDecoder decodeObjectForKey:@"kidneyname"];
        self.Address = [aDecoder decodeObjectForKey:@"Address"];
        self.Nickname = [aDecoder decodeObjectForKey:@"Nickname"];
        self.TEL = [aDecoder decodeObjectForKey:@"TEL"];
        self.Age = [aDecoder decodeObjectForKey:@"Age"];
        self.Sex = [aDecoder decodeObjectForKey:@"Sex"];
        self.Weibo = [aDecoder decodeObjectForKey:@"Weibo"];
        self.TourID = [aDecoder decodeObjectForKey:@"TourID"];
        NSData *imageData=[aDecoder decodeObjectForKey:@"imageData"];
        self.headImage = [UIImage imageWithData:imageData];
    }
    return self;
}
@end
