//
//  PrizeModel.m
//  推盟
//
//  Created by joinus on 16/6/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeModel.h"

@interface PrizeModel ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation PrizeModel


-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        id item = dic[@"prize"];
        NSString * prizeString = @"";
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            NSArray * prize_level = item[@"prize_level"];
            NSArray * prize_reset = item[@"prize_reset"];
            if (prize_level && [prize_level isKindOfClass:[NSArray class]]) {
                if (prize_reset && [prize_reset isKindOfClass:[NSArray class]]) {
                    if (prize_reset.count == prize_level.count) {
                        
                        for (int i = 0; i < prize_level.count; i++) {
                            NSString * level = prize_level[i];
                            NSString * reset = prize_reset[i];
                            NSString * finalString = [NSString stringWithFormat:@"%@：%@名 ",[self changeNum:level],reset];
                            prizeString = [prizeString stringByAppendingString:finalString];
                        }
                    }
                }
            }
            
            if (prizeString) {
                _prizeRestString = [NSString stringWithFormat:@"剩余：%@",prizeString];
            }else {
                _prizeRestString = @"";
            }
        }
    }
    return self;
}


+(instancetype)sharedInstance{
    return [[[self class] alloc] initModel];
}

-(instancetype)initModel{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    
    return self;
}

-(void)loadListDataWithPage:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure{
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"page":@(page)};
    [[ZAPI manager] sendPost:PRIZE_LIST_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if (page == 1) {
                    [wself.dataArray removeAllObjects];
                }
                NSArray * dataArr = data[@"data"];
                for (NSDictionary * dic in dataArr) {
                    PrizeModel * model = [[PrizeModel alloc] initWithDictionary:dic];
                    [wself.dataArray addObject:model];
                }
                
                if (dataArr.count) {
                    if (success) {
                        success(wself.dataArray);
                    }
                }else{
                    if (failure) {
                        failure(@"没有更多数据");
                    }
                }                
            }else{
                if (failure) {
                    failure(data[ERROR_INFO]);
                }
            }
        }
        
    } failure:^(NSError *error) {
        failure(@"请求失败");
    }];
    
}

-(void)loadDetailDataWithTaskID:(NSString *)taskId withSuccess:(void (^)(NSMutableArray * array))success withFailure:(void (^)(NSString * error))failure{
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"task_id":taskId,@"user_id":[ZTools getUid]};
    [[ZAPI manager] sendPost:PRIZE_DETAIL_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                wself.content           = data[@"data"][@"content"];
                wself.task_describe     = data[@"data"][@"task_describe"];
                wself.task_rule         = data[@"data"][@"task_rule"];
                wself.all_click         = data[@"data"][@"all_click"];
                wself.can_draw_num      = data[@"data"][@"can_draw_num"];
                wself.task_draw_num     = data[@"data"][@"task_draw_num"];
                wself.share_img         = data[@"data"][@"share_img"];
                
                if (success) {
                    success(nil);
                }
            }else{
                if (failure) {
                    failure(data[ERROR_INFO]);
                }
            }
        }else{
            failure(@"请求失败");
        }
        
    } failure:^(NSError *error) {
        failure(@"请求失败");
    }];
}


-(void)getPrizeWithTaskID:(NSString *)taskId
                  prizeID:(NSString *)prizeId
                  success:(void(^)(void))success
                   failed:(void(^)(NSString * errorInfo))failed{
    
    NSDictionary * dic = @{@"task_id":taskId,
                           @"user_id":[ZTools getUid],
                           @"did":prizeId
                           };
    [[ZAPI manager] sendPost:PRIZE_CONVERT_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if (success) {
                    success();
                }
            }else {
                if (failed) {
                    failed(data[ERROR_INFO]);
                }
            }
        }else {
            if (failed) {
                failed(@"获取失败");
            }
        }
    } failure:^(NSError *error) {
        if (failed) {
            failed(@"获取失败");
        }
    }];
}

-(NSString *)changeNum:(NSString *)num{
    NSArray * numberchar = @[@"零等奖",@"一等奖",@"二等奖",@"三等奖",@"四等奖",@"五等奖",@"六等奖",@"七等奖",@"八等奖",@"九等奖"];
    return numberchar[num.intValue];
}



@end
