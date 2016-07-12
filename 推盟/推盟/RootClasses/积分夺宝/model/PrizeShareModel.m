//
//  PrizeShareModel.m
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeShareModel.h"

@implementation PrizeShareModel


+(instancetype)sharedInstance{
    return [[[self class] alloc] init];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)loadTitlesDataWithTaskId:(NSString *)taskId success:(void (^)(void))success failed:(void (^)(NSString *))failed
{
    
    NSDictionary * dic = @{@"user_id":[ZTools getUid],@"task_id":taskId};
    __WeakSelf__ wself = self;
    [[ZAPI manager] sendPost:PRIZE_SHARE_TITLES_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                NSArray * array = data[@"title_list"];
                for (NSDictionary * dic in array) {
                    PrizeShareModel * model = [[PrizeShareModel alloc] initWithDictionary:dic];
                    model.task_img = data[@"task_img"];
                    [wself.dataArray addObject:model];
                }
                if (success) {
                    success();
                }
            }else{
                if (failed) {
                    failed(data[ERROR_INFO]);
                }
            }
        }else{
            if (failed) {
                failed(@"请求失败");
            }
        }
    } failure:^(NSError *error) {
        if (failed) {
            failed(@"请求失败");
        }
    }];
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
