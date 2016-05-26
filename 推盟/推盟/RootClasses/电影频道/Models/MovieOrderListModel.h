//
//  MovieOrderListModel.h
//  推盟
//
//  Created by joinus on 16/4/25.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface MovieOrderListModel :BaseModel
/**
 *  订单号
 */
@property(nonatomic,strong) NSString                * pay_no;
/**
 *  订单日期
 */
@property (nonatomic , copy) NSString              * order_data;
/**
 *  影院名称
 */
@property (nonatomic , copy) NSString              * cinema_name;
/**
 *  电影名称
 */
@property (nonatomic , copy) NSString              * movie_name;
/**
 *  影片播放时间
 */
@property (nonatomic , copy) NSString              * feature_time;
/**
 *  座位信息
 */
@property (nonatomic , copy) NSString              * ticket_desc;
/**
 *  订单状态(1：支付成功  2：支付失败  3：未支付)
 */
@property (nonatomic , copy) NSString              * status;
/**
 *
 */
@property (nonatomic , strong) NSString            * tickts_amount;
/**
 *  手续费
 */
@property (nonatomic , copy) NSString              * amount_fee;
/**
 *  价格
 */
@property (nonatomic , strong) NSString            * movie_money;
/**
 *  积分
 */
@property (nonatomic , copy) NSString              * integral;
/**
 *
 */
@property (nonatomic , copy) NSString              * movie_img;
/**
 *  影厅名称
 */
@property (nonatomic , copy) NSString              * hallName;
/**
 *  总价格
 */
@property (nonatomic , copy) NSString              * all_money;
/**
 *  支付日期
 */
@property (nonatomic , copy) NSString              * pay_data;
/**
 *  影厅名称
 */
@property(nonatomic,strong)  NSString              * hall_name;





@end