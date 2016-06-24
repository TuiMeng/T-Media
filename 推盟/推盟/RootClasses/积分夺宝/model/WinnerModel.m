//
//  WinnerModel.m
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "WinnerModel.h"

@interface WinnerModel ()


@end

@implementation WinnerModel



-(void)loadListDataWithTaskId:(NSString *)taskId page:(int)page withSuccess:(void (^)(NSMutableArray * array))success withFailure:(void (^)(NSString * errorinfo))failure{
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"task_id":taskId,@"page":@(page),@"user_id":([ZTools isLogIn]?[ZTools getUid]:@"1")};
    [[ZAPI manager] sendPost:WINNER_LIST_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if (page == 1) {
                    [wself.dataArray removeAllObjects];
                }
                NSArray * dataArr = data[@"data"];
                for (NSDictionary * dic in dataArr) {
                    WinnerModel * model = [[WinnerModel alloc] initWithDictionary:dic];
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


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}








@end
