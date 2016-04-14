//
//  RootTaskListModel.h
//  推盟
//
//  Created by joinus on 15/8/6.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface RootTaskListModel : BaseModel


///任务id
@property(nonatomic,strong)NSString * encrypt_id;
///任务名
@property(nonatomic,strong)NSString * task_name;
///总金额
@property(nonatomic,strong)NSString * total_task;
///t图片
@property(nonatomic,strong)NSString * task_img;
///链接
@property(nonatomic,strong)NSString * content;
//地区
@property(nonatomic,strong)NSString * area;
//任务状态值(1:正在进行中，2：已暂停，0：已结束)
@property(nonatomic,strong)NSString * task_status;
/**
 *  任务所属类型id
 */
@property(nonatomic,strong)NSString * column_id;
//任务所属类型名称
@property(nonatomic,strong)NSString * column_name;
/**
 *  普通用户任务单价
 */
@property(nonatomic,strong)NSString * task_price;
/**
 *  高级用户任务单价
 */
@property(nonatomic,strong)NSString * gao_click_price;
/**
 *  投放平台(微信|朋友圈|QQ好友|QQ空间|豆瓣网|新浪)
 */
@property(nonatomic,strong)NSString * spread_type;
/**
 *  任务时间
 */
@property(nonatomic,strong)NSString * create_time;

@end
