//
//  UserTaskModel.h
//  推盟
//
//  Created by soulnear on 14-8-19.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTaskModel : BaseModel
{
    
}

///任务名称
@property(nonatomic,strong)NSString * task_name;
///任务累计点击
@property(nonatomic,strong)NSString * click_num;
///累计积分
@property(nonatomic,strong)NSString * get_points;
/**
 *  普通用户点击单价
 */
@property(nonatomic,strong)NSString * task_price;
/**
 *  任务id
 */
@property(nonatomic,strong)NSString * tid;
///高级用户点击价格
@property(nonatomic,strong)NSString * gao_click_price;


@end
