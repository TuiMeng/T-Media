//
//  InvitationModel.m
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "InvitationModel.h"

@implementation InvitationModel


-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        _friend_list_array = [NSMutableArray array];
        NSArray * array = [dic objectForKey:@"friend_list"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            for (NSDictionary * obj in array) {
                [_friend_list_array addObject:obj];
            }
        }
    }
    return self;
}


@end
