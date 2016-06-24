//
//  PrizeDetailViewController.h
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyViewController.h"
#import "PrizeModel.h"

@interface PrizeDetailViewController : MyViewController


@property(nonatomic,strong)PrizeModel   * model;

@property(nonatomic,strong)NSString     * prizeId;

@end
