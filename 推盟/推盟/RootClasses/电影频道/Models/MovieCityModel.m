//
//  MovieCityModel.m
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieCityModel.h"


@implementation SubCityModel



@end


@implementation MovieCityModel


-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        _city_array = [NSMutableArray array];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            id citys = [dic objectForKey:@"citys"];
            if (citys && [citys isKindOfClass:[NSArray class]]) {
                for (NSDictionary * item in citys) {
                    SubCityModel * model = [[SubCityModel alloc] initWithDictionary:item];
                    [_city_array addObject:model];
                }
            }
        }
    }
    
    return self;
}



@end
