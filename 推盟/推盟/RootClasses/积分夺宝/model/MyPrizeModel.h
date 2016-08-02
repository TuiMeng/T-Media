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

@interface PrizeStatusModel : BaseModel

/**
 *  抽奖id
 */
@property(nonatomic,strong)NSString * did;
/**
 *  奖品名称
 */
@property(nonatomic,strong)NSString * prize_name;
/**
 *  奖品id
 */
@property(nonatomic,strong)NSString * prize_id;
/**
 *  是否是虚拟物品
 （1-虚拟物品，2实体物品）
 */
@property(nonatomic,strong)NSString * isVirtual;
/**
 *  抽奖日期
 */
@property(nonatomic,strong)NSString * date;
/**
 *  是否可以领取奖品（1-没有领取，2-已领取）
 */
@property(nonatomic,strong)NSString * canAcceptPrize;
/**
 * 审核状态（1-未审核，2-审核通过，3-审核未通过）
 */
@property(nonatomic,strong)NSString * Status;
/**
 *  拒绝原因
 */
@property(nonatomic,strong)NSString * Reason;
/**
 *  运单号
 */
@property(nonatomic,strong)NSString * orderNo;
/**
 *  虚拟物品账号或兑换码
 */
@property(nonatomic,strong)NSString * account;
/**
 *  虚拟物品密码
 */
@property(nonatomic,strong)NSString * pwd;
/**
 *  物流平台
 */
@property(nonatomic,strong)NSString * Platform;


@end



@interface MyPrizeModel : BaseModel


/**
 *  活动id
 */
@property(nonatomic,strong)NSString * task_id;
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
 *  类型（1：已中奖  2：未中奖 空：未抽奖）
 */
@property(nonatomic,strong)NSString * type;
/**
 *  奖品信息
 */
@property(nonatomic,strong)NSMutableArray * prizes;





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
