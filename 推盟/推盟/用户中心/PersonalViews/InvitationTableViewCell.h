//
//  InvitationTableViewCell.h
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationTableViewCell : UITableViewCell


/**
 *  手机号码
 */
@property (strong, nonatomic) UILabel *phone_num_label;

/**
 *  昵称
 */
@property (strong, nonatomic) UILabel *user_name_label;

/**
 *  日期
 */
@property (strong, nonatomic) UILabel *date_label;

-(void)setInfomationWith:(NSDictionary*)dic;

@end
