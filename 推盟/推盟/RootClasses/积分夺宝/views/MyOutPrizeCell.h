//
//  MyOutPrizeCell.h
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//
/*
 *  未中奖视图
 */

#import <UIKit/UIKit.h>
#import "MyPrizeModel.h"

@interface MyOutPrizeCell : UITableViewCell


//内容背景视图
@property(nonatomic,strong)UIView           * contentBackView;
//内容标题
@property(nonatomic,strong)UILabel          * contentLabel;
//点击/抽奖次数
@property(nonatomic,strong)UILabel          * clickAndLotteryNum;




-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model;


@end
