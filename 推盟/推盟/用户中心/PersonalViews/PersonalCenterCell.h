//
//  PersonalCenterCell.h
//  推盟
//
//  Created by joinus on 15/8/5.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTaskModel.h"

@interface PersonalCenterCell : UITableViewCell
/**
 *  任务标题
 */
@property (weak, nonatomic) IBOutlet SLabel *title_label;
/**
 *  任务累计点击数量
 */
@property (weak, nonatomic) IBOutlet UILabel *clicked_num_label;
/**
 *  任务累计奖金
 */
@property (weak, nonatomic) IBOutlet UILabel *total_money_label;

@property (weak, nonatomic) IBOutlet UIView *background_view;



-(void)setInfomationWithModel:(UserTaskModel*)info;

@end
