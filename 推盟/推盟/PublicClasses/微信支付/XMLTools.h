//
//  XMLTools.h
//  推盟
//
//  Created by joinus on 16/3/21.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLTools : NSObject<NSXMLParserDelegate> {
    
    //解析器
    NSXMLParser *xmlParser;
    //解析元素
    NSMutableArray *xmlElements;
    //解析结果
    NSMutableDictionary *dictionary;
    //临时串变量
    NSMutableString *contentString;
}
//输入参数为xml格式串，初始化解析器
-(void)startParse:(NSData *)data;
//获取解析后的字典
-(NSMutableDictionary*) getDict;

@end
