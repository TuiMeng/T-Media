//
//  UserInfoModel.m
//  推盟
//
//  Created by soulnear on 14-8-19.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "UserInfoModel.h"


@implementation UserAddressModel



@end



@implementation UserInfoModel
@synthesize user_name = _user_name;
@synthesize user_mobile = _user_mobile;
@synthesize trade =_trade;
@synthesize company = _company;
@synthesize bank = _bank;
@synthesize bank_card = _bank_card;
@synthesize bank_name = _bank_name;
@synthesize user_age = _user_age;
@synthesize user_gender = _user_gender;
@synthesize user_city = _user_city;

-(UserInfoModel *)initWithDic:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        
    }
    return self;
}





@end
















