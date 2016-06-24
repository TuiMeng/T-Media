//
//  MyPrizeModel.h
//  推盟
//
//  Created by joinus on 16/6/12.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  我的夺宝历史数据
 */

#import "BaseModel.h"

@interface MyPrizeModel : BaseModel

/**
 *  奖品名称
 */
@property(nonatomic,strong)NSString * prize_name;
/**
 *  任务标题
 */
@property(nonatomic,strong)NSString * task_name;
/**
 *  任务内容
 */
@property(nonatomic,strong)NSString * task_content;
/**
 *  点击次数
 */
@property(nonatomic,strong)NSString * all_click;
/**
 *  抽奖次数
 */
@property(nonatomic,strong)NSString * drawed_num;
/**
 *  奖品id
 */
@property(nonatomic,strong)NSString * prize_id;
/**
 *  类型（1：已中奖  2：未中奖）
 */
@property(nonatomic,strong)NSString * type;
/**
 *  活动id
 */
@property(nonatomic,strong)NSString * task_id;
/**
 *  抽奖日期
 */
@property(nonatomic,strong)NSString * date;
/**
 * 订单状态（审核中，拒绝，通过）
 */
@property(nonatomic,strong)NSString * status;
/**
 *  物流平台
 */
@property(nonatomic,strong)NSString * platform;
/**
 *  拒绝原因
 */
@property(nonatomic,strong)NSString * reason;
/**
 *  运单号
 */
@property(nonatomic,strong)NSString * orderNo;
/**
 *  是否为虚拟物品
 */
@property(nonatomic,strong)NSString * isVirtual;
/**
 *  是否可以领取奖品
 */
@property(nonatomic,strong)NSString * canAcceptPrize;



@property(nonatomic,strong)NSArray * dataArray;

/**
 *  夺宝历史
 *
 *  @param type    1：已中奖  2：未中奖
 *  @param page    页数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)loadListDataWithType:(int)type page:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure;


@end
