//
//  GiftRecordModel.h
//  推盟
//
//  Created by joinus on 15/8/24.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/**
 *  礼品兑换记录
 */

#import "BaseModel.h"

@interface GiftRecordModel : BaseModel

/**
 *  类型(1：话费充值；2：电影票兑换券；3：视频网站会员兑换券)
 */
@property(nonatomic,strong)NSString * type;
/**
 *  id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  礼品id
 */
@property(nonatomic,strong)NSString * gift_id;
/**
 *  名称
 */
@property(nonatomic,strong)NSString * gift_name;
/**
 *  价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  小图
 */
@property(nonatomic,strong)NSString * gift_image_small;
/**
 *  充值的手机号码
 */
@property(nonatomic,strong)NSString * phone_num;
/**
 *  状态值
 */
@property(nonatomic,strong)NSString * status;
/**
 *  话费充值时间（时间戳，需要自己转换）
 */
@property(nonatomic,strong)NSString * recharge_time;
/**
 *  券码
 */
@property(nonatomic,strong)NSString * number;
/**
 *  开始时间（返回日期，直接显示）
 */
@property(nonatomic,strong)NSString * start_time;
/**
 *  结束时间（返回日期，直接显示）
 */
@property(nonatomic,strong)NSString * end_time;
/**
 *  拒绝原因
 */
@property(nonatomic,strong)NSString * reason;
/**
 *  处理时间（时间戳，需要自己转换）
 */
@property(nonatomic,strong)NSString * handling_time;
/**
 *  礼品 密码
 */
@property(nonatomic,strong)NSString * password;





@end
