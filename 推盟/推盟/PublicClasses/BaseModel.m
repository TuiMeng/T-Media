//
//  SNModel.m
//  RKAStore
//
//  Created by soulnear on 15/3/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey %@",key);
}
@end
