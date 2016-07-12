//
//  WinnerModel.h
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface WinnerModel : BaseModel

/**
 *  中奖人手机号码
 */
@property(nonatomic,strong)NSString * user_mobile;
/**
 *  总点击数
 */
@property(nonatomic,strong)NSString * all_click;
/**
 *  奖品名称
 */
@property(nonatomic,strong)NSString * prize_name;
/**
 *  中奖日期
 */
@property(nonatomic,strong)NSString * draw_time;
/**
 *  用户id
 */
@property(nonatomic,strong)NSString * uid;
/**
 *  任务id
 */
@property(nonatomic,strong)NSString * tid;


/**
 *  数据
 */
@property(nonatomic,strong)NSMutableArray * dataArray;




-(void)loadListDataWithTaskId:(NSString *)taskId withSuccess:(void (^)(NSMutableArray * array))success withFailure:(void (^)(NSString * errorinfo))failure;


@end
