//
//  WXUtil.h
//  推盟
//
//  Created by joinus on 16/3/21.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface WXUtil : NSObject{
    
}
/*
 加密实现MD5和SHA1
 */
+(NSString *) md5:(NSString *)str;
+(NSString*) sha1:(NSString *)str;
/**
 实现http GET/POST 解析返回的json数据
 */
+(NSData *) httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data;


@end
