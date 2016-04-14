//
//  TaskInfo.m
//  推盟
//
//  Created by joinus on 16/1/12.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "TaskInfo.h"

@implementation TaskInfo

// Insert code here to add functionality to your managed object subclass

-(void)setValueWithDictionary:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [self setValuesForKeysWithDictionary:dic];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey %@",key);
}

@end
