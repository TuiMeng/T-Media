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

+(instancetype)shareInstance {
    return [[[self class] alloc] init];
}


-(void)loadPersonInfoWithSuccess:(void (^)(UserInfoModel *))success failed:(void (^)(NSString *))failed{
    
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",GET_USERINFOMATION_URL,[ZTools getUid]] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                UserInfoModel * model = [[UserInfoModel alloc] initWithDictionary:[data objectForKey:@"user_info"]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[data objectForKey:@"user_info"]] forKey:@"UserInfomationData"];
                if (success) {
                    success(model);
                }
            }else {
                if (failed) {
                    failed(data[ERROR_INFO]);
                }
            }
        }else {
            if (failed) {
                failed(@"请求失败");
            }
        }
    } failure:^(NSError *error) {
        if (failed) {
            failed(@"请求失败");
        }
    }];
}


-(void)dealloc {
    
}

@end
















