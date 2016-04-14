//
//  InvitationModel.h
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/**
 *  邀请好友
 */
#import "BaseModel.h"

@interface InvitationModel : BaseModel

/**
 *  状态值
 */
@property(nonatomic,strong)NSString * status;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString * errorinfo;
/**
 *  获取的总返利
 */
@property(nonatomic,strong)NSString * total_rebate;
/**
 *  邀请的总人数
 */
@property(nonatomic,strong)NSString * total_per;
/**
 *  我的邀请码
 */
@property(nonatomic,strong)NSString * invitation_num;
/**
 *  被邀请的人员列表
 */
@property(nonatomic,strong)NSMutableArray * friend_list_array;



-(id)initWithDictionary:(NSDictionary *)dic;
@end
