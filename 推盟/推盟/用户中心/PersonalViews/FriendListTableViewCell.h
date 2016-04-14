//
//  FriendListTableViewCell.h
//  推盟
//
//  Created by joinus on 15/12/29.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListModel.h"

@interface FriendListTableViewCell : UITableViewCell
/**
 *  用户名
 */
@property (strong, nonatomic) IBOutlet UILabel *user_name_label;
/**
 *  手机号（中间四位加密的）
 */
@property (strong, nonatomic) IBOutlet UILabel *user_phone_num_label;
/**
 *  注册时间
 */
@property (strong, nonatomic) IBOutlet UILabel *user_register_label;


-(void)setInfomationWithFriendListModel:(FriendListModel*)model;


@end
