//
//  MovieCityViewController.h
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyViewController.h"
#import "MovieCityModel.h"


typedef void(^MovieCityViewControllerBlock)(MovieCityModel * model);

@interface MovieCityViewController : MyViewController{
    MovieCityViewControllerBlock city_block;
}

@property(nonatomic,strong)NSString * current_city;


-(void)selectedCityWithCityBlock:(MovieCityViewControllerBlock)block;

@end
