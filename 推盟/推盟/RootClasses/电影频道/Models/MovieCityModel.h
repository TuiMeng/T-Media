//
//  MovieCityModel.h
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"


@interface SubCityModel : BaseModel

@property(nonatomic,strong)NSString * cityId;
@property(nonatomic,strong)NSString * cityName;

@end


@interface MovieCityModel : BaseModel

@property(nonatomic,strong)NSString * province;

@property(nonatomic,strong)NSMutableArray * city_array;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
