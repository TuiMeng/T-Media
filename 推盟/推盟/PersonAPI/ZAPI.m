//
//  ZAPI.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ZAPI.h"

@implementation ZAPI

+(instancetype)manager{
    return [[[self class]alloc]initWithBaseURL:nil];
}
-(instancetype)initWithBaseURL:(NSURL *)url{
    
    self = [super init];
    
    if ( self ) {
        self.baseURL = url;
    }
    
    return self;
}

#pragma mark - 同步请求
//GET的异步请求 - 暂时没人用
-(void)sendGet:(NSString *)rawURL myParams:(NSDictionary *)params
       success:(void (^)(NSDictionary *data))success
       failure:(void (^)(NSError *error))failure{
    
    //实例化AF对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //开始传输
    [self requireNetworkConnection:YES];
    [manager GET:rawURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleReceivedData:responseObject JSONDecode:NO];
        if (success) {
            success(self.responseResult);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //处理网络错误
         NSLog(@"%@",error);    [self requireNetworkConnection:NO];
         if (failure) {
             failure(error);
         }
     }];
    
}
-(void)handleReceivedData:(id)received JSONDecode:(BOOL)JSONDecode{
    if (received) {
        if (JSONDecode) {
            
            NSError *e = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:(NSData *)received options:kNilOptions error:&e];
            
            self.responseResult = result;
            
        }else {
            
            self.responseResult = received;
        }
    }
    NSLog(@"%@",self.responseResult);
    
    [self requireNetworkConnection:NO];
}


-(void)requireNetworkConnection:(BOOL)status{
    UIApplication *application = [UIApplication sharedApplication];
    if (status) {
        application.networkActivityIndicatorVisible=YES;
    }else{
        application.networkActivityIndicatorVisible=NO;
    }
}


#pragma mark - 异步请求
//POST的异步请求
-(void)sendPost:(NSString *)rawURL myParams:(NSDictionary *)params
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setObject:CURRENT_VERSION forKey:@"appversion"];
    [dic setObject:@"1" forKey:@"from_type"];
    
    NSURL *url = [NSURL URLWithString:[rawURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 获取参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self buildData:dic]];
    
    [self afHttpRequestWith:request success:success failure:failure];
    
}
//电影数据不需要提供平台版本号
-(void)sendMoviePost:(NSString *)rawURL myParams:(NSDictionary *)params
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSURL *url = [NSURL URLWithString:[rawURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 获取参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self buildData:dic]];
    
    [self afHttpRequestWith:request success:success failure:failure];
    
}

-(void)sendGet:(NSString *)rawURL success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    rawURL = [NSString stringWithFormat:@"%@&appversion=%@&from_type=1",rawURL,CURRENT_VERSION];
    NSURL * url = [NSURL URLWithString:[rawURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self afHttpRequestWith:request success:success failure:failure];
}
//电影数据不需要提供平台版本号
-(void)sendMovieGet:(NSString *)rawURL success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSURL * url = [NSURL URLWithString:[rawURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self afHttpRequestWith:request success:success failure:failure];
}


-(void)afHttpRequestWith:(NSURLRequest *)request success:(void (^)(id data))success
                 failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
        
        if (success) {
            success(dict);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        if (failure) {
            failure(error);
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(BOOL)is_array:(id)target{
    
    if ([target isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
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


#pragma mark ---------  匹配ip地区



@end















