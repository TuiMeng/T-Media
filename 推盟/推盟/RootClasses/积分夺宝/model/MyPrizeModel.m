//
//  MyPrizeModel.m
//  推盟
//
//  Created by joinus on 16/6/12.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyPrizeModel.h"

@implementation PrizeStatusModel



@end

@implementation MyPrizeModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        _prizes = [NSMutableArray array];
        id prize = dic[@"prize"];
        if (prize && [prize isKindOfClass:[NSArray class]]) {
            NSArray * prizeArray = (NSArray *)prize;
            for (NSDictionary * item in prizeArray) {
                PrizeStatusModel * model = [[PrizeStatusModel alloc] initWithDictionary:item];
                [_prizes addObject:model];
            }
        }
    }
    
    return self;
}

-(void)loadListDataWithType:(int)type page:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure{
    __WeakSelf__ wself = self;
    
    NSDictionary * dic = @{@"page":@(page),@"type":@(type),@"user_id":[ZTools getUid]};
    [[ZAPI manager] sendPost:LOTTERY_LIST_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if (page == 1) {
                    [wself.dataArray[type-1] removeAllObjects];
                }
                NSArray * dataArr = data[@"data"];
                for (NSDictionary * dic in dataArr) {
                    MyPrizeModel * model = [[MyPrizeModel alloc] initWithDictionary:dic];
                    if (type == 1)//如果是请求已中奖信息，先判断该条数据有没有中奖信息，如果没有删除该条数据
                    {
                        if (model.prizes.count != 0) {
                            [wself.dataArray[type-1] addObject:model];
                        }
                    }else {
                        [wself.dataArray[type-1] addObject:model];
                    }
                }
                
                if (success) {
                    success(wself.dataArray[type-1]);
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

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[[NSMutableArray array],[NSMutableArray array]];
    }
    return _dataArray;
}






@end
