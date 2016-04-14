//
//  UserInfoModel.h
//  推盟
//
//  Created by soulnear on 14-8-19.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : BaseModel
{
    
}

///用户名
@property(nonatomic,strong)NSString * user_name;
///用户手机号
@property(nonatomic,strong)NSString * user_mobile;
///用户认证状态(1已认证0未认证2审核中)
@property(nonatomic,strong)NSString * check_status;
///用户头像
@property(nonatomic,strong)NSString * head;
///用户行业
@property(nonatomic,strong)NSString * trade;
///用户认证照片
@property(nonatomic,strong)NSString * photo;
///工作单位
@property(nonatomic,strong)NSString * company;
///工作年限
@property(nonatomic,strong)NSString * life;
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


-(UserInfoModel *)initWithDic:(NSDictionary *)dic;




@end










