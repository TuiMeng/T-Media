//
//  PrizeShareModel.h
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  分享数据模型
 */

#import "BaseModel.h"

@interface PrizeShareModel : BaseModel

@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * title_name;
@property(nonatomic,strong)NSString * share_type;
@property(nonatomic,strong)NSString * task_img;


@property(nonatomic,strong)NSMutableArray * dataArray;


+(instancetype)sharedInstance;

-(void)loadTitlesDataWithTaskId:(NSString *)taskId success:(void(^)(void))success failed:(void(^)(NSString * errorInfo))failed;


@end
