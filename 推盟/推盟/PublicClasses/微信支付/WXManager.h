//
//  WXRequestHandler.h
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WXManager : NSObject{
    //lash_errcode;
    long     last_errcode;
}


//预支付网关url地址
@property (nonatomic,strong) NSString* payUrl;

//debug信息
@property (nonatomic,strong) NSMutableString *debugInfo;
@property (nonatomic,assign) NSInteger lastErrCode;//返回的错误码

//商户关键信息
@property (nonatomic,strong) NSString *appId,*mchId,*spKey;



//初始化函数
-(id)initWithAppID:(NSString*)appID
             mchID:(NSString*)mchID
             spKey:(NSString*)key;

//获取当前的debug信息
-(NSString *) getDebugInfo;

//获取预支付订单信息（核心是一个prepayID）
- (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name
                                         price:(NSString*)price
                                        device:(NSString*)device
                                       orderId:(NSString *)orderId;


@end
