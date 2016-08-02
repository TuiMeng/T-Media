//
//  PrizeCell.h
//  推盟
//
//  Created by joinus on 16/6/4.
//  Copyright © 2016年 joinus. All rights reserved.
//
/*
 *  该用户在该任务中奖信息展示
 */

#import <UIKit/UIKit.h>
#import "PrizeModel.h"
#import "CLRollLabel.h"

@interface PrizeCell : UITableViewCell

//背景视图
@property(nonatomic,strong)UIView       * backView;
//头图
@property(nonatomic,strong)UIImageView  * imageV;
//标题背景图
@property(nonatomic,strong)UIView       * titleView;
//标题
@property(nonatomic,strong)CLRollLabel  * titleLabel;
//剩余数量
@property(nonatomic,strong)UILabel      * restLabel;
//已结束提示视图
@property(nonatomic,strong)UIImageView  * endRemindImageView;
////进度条
//@property(nonatomic,strong)CAShapeLayer * progress_hud;


-(void)setInfomationWithPrizeModel:(PrizeModel *)model;

@end
