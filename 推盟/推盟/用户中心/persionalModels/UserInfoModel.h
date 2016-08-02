//
//  UserInfoModel.h
//  推盟
//
//  Created by soulnear on 14-8-19.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface UserAddressModel : BaseModel
/**
 *  收货人姓名
 */
@property(nonatomic,strong)NSString * put_man;
/**
 *  收货人所在省市
 */
@property(nonatomic,strong)NSString * user_city;
/**
 *  收货人详细地址
 */
@property(nonatomic,strong)NSString * user_area;
/**
 *  邮编
 */
@property(nonatomic,strong)NSString * user_email;

@end




@interface UserInfoModel : BaseModel
{
    
}

///用户名
@property(nonatomic,strong)NSString * user_name;
///用户手机号
@property(nonatomic,strong)NSString * user_mobile;
///用户行业
@property(nonatomic,strong)NSString * trade;
///工作单位
@property(nonatomic,strong)NSString * company;
///银行名称
@property(nonatomic,strong)NSString * bank;
///银行卡号
@property(nonatomic,strong)NSString * bank_card;
///银行卡户名
@property(nonatomic,strong)NSString * bank_name;
///用户年龄
@property(nonatomic,strong)NSString * user_age;
///用户性别
@property(nonatomic,strong)NSString * user_gender;
///用户所在地
@property(nonatomic,strong)NSString * user_city;
///用户邀请码
@property(nonatomic,strong)NSString * invite_code;
///支付宝开户人姓名
@property(nonatomic,strong)NSString * alipay_name;
///支付宝账号
@property(nonatomic,strong)NSString * alipay_num;
///用用户性别
@property(nonatomic,strong)NSString * user_sex;
/**
 *  用户等级1:普通用户，2：高级用户
 */
@property(nonatomic,strong)NSString * grade;
/**
 *  ip地址
 */
@property(nonatomic,strong)NSString * user_ip;
/**
 *  兴趣标签
 */
@property(nonatomic,strong)NSString * hobby_id;
/**
 *  账户余额
 */
@property(nonatomic,strong)NSString * rest_money;
/**
 *  历史总额
 */
@property(nonatomic,strong)NSString * all_money;
/**
 *  提现金额
 */
@property(nonatomic,strong)NSString * money;
/**
 *  邀请人获得的奖励
 */
@property(nonatomic,strong)NSString * invited_money;
/**
 *  被邀请人获得的奖励
 */
@property(nonatomic,strong)NSString * be_invited_money;
/**
 *
 */
@property(nonatomic,strong)NSString * user_type;
/**
 *  用户姓名
 */
@property(nonatomic,strong)NSString * user_namea;
/**
 *  身份证号码
 */
@property(nonatomic,strong)NSString * idnumber;
/**
 *
 */
@property(nonatomic,strong)NSString * invite_uid;
/**
 *
 */
@property(nonatomic,strong)NSString * mobile_area;
/**
 *
 */
@property(nonatomic,strong)NSString * user_status;
/**
 *
 */
@property(nonatomic,strong)NSString * regist_time;
/**
 *
 */
@property(nonatomic,strong)NSString * encrypt_id;
/**
 *
 */
@property(nonatomic,strong)NSString * invite_status;

//网络请求
@property(nonatomic,strong)NSURLSessionDataTask * task;



-(UserInfoModel *)initWithDic:(NSDictionary *)dic;

+(instancetype)shareInstance;

-(void)loadPersonInfoWithSuccess:(void(^)(UserInfoModel * model))success failed:(void(^)(NSString * error))failed;



@end










