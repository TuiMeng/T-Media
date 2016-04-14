//
//  ApplyRecordModel.h
//  推盟
//
//  Created by joinus on 15/8/24.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface ApplyRecordModel : BaseModel


/**
 *  id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  申请时间
 */
@property(nonatomic,strong)NSString * create_time;
/**
 *  提现金额
 */
@property(nonatomic,strong)NSString * money;
/**
 *  审核状态
 */
@property(nonatomic,strong)NSString * solve_status;
/**
 *  处理时间
 */
@property(nonatomic,strong)NSString * solve_time;
/**
 *  拒绝原因
 */
@property(nonatomic,strong)NSString * reason;

@end
