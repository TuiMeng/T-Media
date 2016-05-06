//
//  MovieNetWork.m
//  推盟
//
//  Created by joinus on 16/4/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieNetWork.h"

@implementation MovieNetWork


+ (MovieNetWork *)sharedManager
{
    static MovieNetWork *sharedMovie = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedMovie = [[self alloc] init];
    });
    return sharedMovie;
}

#pragma mark ------   网络请求
-(void)releaseMovieSeatsWithOrderId:(NSString *)orderId{
    if (!queue) {
        queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 1;
    }
    
    NSURL *url = [NSURL URLWithString:[MOVIE_RELEASE_SEAT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // 获取参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self buildData:@{@"pay_no":orderId.length?orderId:@""}]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
    }];
    
    [queue addOperation:operation];
}

-(void)checkCityIdWitCityName:(NSString *)name success:(void(^)(NSString * id))success failure:(void(^)(NSString *error))failure{
    [[ZAPI manager] sendMoviePost:M_GET_CITY_ID_URL myParams:@{@"cityName":name.length?name:@""} success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * message = data[MOVIE_ERROR_INFO];
            if (message.length == 0) {
                [ZTools setSelectedCity:name cityId:data[@"cityId"]];
                success(data[@"cityId"]);
            }else{
                failure(message.length?message:@"切换失败");
            }
        }
    } failure:^(NSError *error) {
        failure(@"切换失败...");
    }];
}

-(NSData*)buildData:(NSDictionary*)dic{
    
    if (![dic isKindOfClass:[dic class]]) {
        return nil;
    }
    
    NSMutableString * stringWithKeyAndValue = [[NSMutableString alloc]init];
    NSArray * keys = [dic allKeys];
    for (NSString * key in keys) {
        [stringWithKeyAndValue appendString:[NSString stringWithFormat:@"&%@=%@",key,dic[key]]];
        
    }
    
    return  [stringWithKeyAndValue dataUsingEncoding:NSUTF8StringEncoding];
}



#pragma mark -------  倒计时
-(void)orderTimerStartTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats TotalCount:(int)count timer:(movieOrderTimerBlock)block{
    timerBlock      = block;
    totalCount      = count;
    if (!timer) {
        timer       = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(countDown) userInfo:nil repeats:repeats];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else{
        [timer fire];
    }
}

-(void)countDown{
    totalCount--;

    if (timerBlock) {
        timerBlock(totalCount,timer);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_STRING object:@(totalCount) userInfo:nil];
}

-(void)checkTimer:(movieOrderTimerBlock)block{
    timerBlock  = block;
}

-(void)endTimer{
    [timer invalidate];
    timer = nil;
}

@end










