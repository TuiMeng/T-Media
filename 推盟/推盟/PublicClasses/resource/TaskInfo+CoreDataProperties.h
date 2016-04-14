//
//  TaskInfo+CoreDataProperties.h
//  推盟
//
//  Created by joinus on 16/1/12.
//  Copyright © 2016年 joinus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TaskInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskInfo (CoreDataProperties)
/**
 *  地区
 */
@property (nullable, nonatomic, retain) NSString *area;
/**
 *  任务所属类别
 */
@property (nullable, nonatomic, retain) NSString *column_name;
/**
 *  内容地址
 */
@property (nullable, nonatomic, retain) NSString *content;
/**
 *  创建时间
 */
@property (nullable, nonatomic, retain) NSString *create_time;
/**
 *  任务id
 */                                               
@property (nullable, nonatomic, retain) NSString *encrypt_id;
/**
 *  高级用户点击价格
 */
@property (nullable, nonatomic, retain) NSString *gao_click_price;
/**
 *  任务图片
 */
@property (nullable, nonatomic, retain) NSString *task_img;
/**
 *  任务名称
 */
@property (nullable, nonatomic, retain) NSString *task_name;
/**
 *  普通用户点击价格
 */
@property (nullable, nonatomic, retain) NSString *task_price;
/**
 *  任务状态值(1:正在进行中，2：已暂停，0：已结束)
 */
@property (nullable, nonatomic, retain) NSString *task_status;
/**
 *  任务总额
 */
@property (nullable, nonatomic, retain) NSString *total_task;
/**
 *  备用字段1
 */
@property (nullable, nonatomic, retain) NSString *extra1;
@property (nullable, nonatomic, retain) NSString *extra2;
@property (nullable, nonatomic, retain) NSString *extra3;
@property (nullable, nonatomic, retain) NSString *extra4;
@property (nullable, nonatomic, retain) NSString *extra5;

@end

NS_ASSUME_NONNULL_END
