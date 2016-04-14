//
//  ApplyMoneyCell.h
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyRecordModel.h"

@interface ApplyMoneyCell : UITableViewCell
/**
 *  申请日期
 */
@property(nonatomic,strong)UILabel * apply_date_label;
/**
 *  处理日期
 */
@property(nonatomic,strong)UILabel * handle_date_label;
/**
 *  提现金额
 */
@property(nonatomic,strong)UILabel * total_moeny_label;
/**
 *  处理状态
 */
@property(nonatomic,strong)UILabel * status_label;


-(void)setInfomationWith:(ApplyRecordModel*)model;

@end
