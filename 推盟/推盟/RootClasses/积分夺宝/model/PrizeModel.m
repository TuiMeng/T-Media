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

@property(nonatomic,assign)int page;

@end

@implementation PrizeModel

+(instancetype)sharedInstance{
    return [[[self class] alloc] initModel];
}

-(instancetype)initModel{
    self = [super init];
    if (self) {
        _page = 1;
    }
    
    return self;
}

-(void)loadDataWithPage:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure{
    NSDictionary * dic = @{@"page":@(page)};
    [[ZAPI manager] sendPost:PRIZE_LIST_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                
                NSArray * dataArr = data[@"data"];
                
                NSMutableArray * tempArray = [NSMutableArray array];
                for (NSDictionary * dic in dataArr) {
                    PrizeModel * model = [[PrizeModel alloc] initWithDictionary:dic];
                    [tempArray addObject:model];
                }
                
                if (success) {
                    success(tempArray);
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










@end
