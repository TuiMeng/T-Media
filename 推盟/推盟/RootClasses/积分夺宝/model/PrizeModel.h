//
//  PrizeModel.h
//  推盟
//
//  Created by joinus on 16/6/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface PrizeModel : BaseModel

/**
 *  活动id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  活动加密id
 */
@property(nonatomic,strong)NSString * encrypt_id;
/**
 *  活动标题
 */
@property(nonatomic,strong)NSString * task_name;
/**
 *  奖品图片（单张）
 */
@property(nonatomic,strong)NSString * task_img;
/**
 *  奖品图片（多张）
 */
@property(nonatomic,strong)NSArray * imgarr;
/**
 *  活动状态(1:在线)
 */
@property(nonatomic,strong)NSString * task_status;
/**
 *  奖品总数量
 */
@property(nonatomic,strong)NSString * task_prize_num;
/**
 *  奖品剩余数量
 */
@property(nonatomic,strong)NSString * task_prize_surplus;
/**
 *  活动开始时间
 */
@property(nonatomic,strong)NSString * task_create_time;
/**
 *  活动结束时间
 */
@property(nonatomic,strong)NSString * task_end_time;
/**
 *  活动内容地址
 */
@property(nonatomic,strong)NSString * task_content;
/**
 *  活动内容地址
 */
@property(nonatomic,strong)NSString * content;
/**
 *  奖品介绍
 */
@property(nonatomic,strong)NSString * task_describe;
/**
 *  活动规则
 */
@property(nonatomic,strong)NSString * task_rule;
/**
 *  点击次数
 */
@property(nonatomic,strong)NSString * all_click;
/**
 * 可抽奖次数
 */
@property(nonatomic,strong)NSString * can_draw_num;
/**
 *  点击多少次可以抽奖
 */
@property(nonatomic,strong)NSString * task_draw_num;


+(instancetype)sharedInstance;

//获取奖品列表
-(void)loadListDataWithPage:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure;
//获取奖品详情
-(void)loadDetailDataWithTaskID:(NSString *)taskId withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure;
//领取奖品
-(void)getPrizeWithTaskID:(NSString *)taskId prizeID:(NSString *)prizeId success:(void(^)(void))success failed:(void(^)(NSString * errorInfo))failed;

@end
