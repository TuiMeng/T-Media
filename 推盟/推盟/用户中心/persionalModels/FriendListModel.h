//
//  FriendListModel.h
//  推盟
//
//  Created by joinus on 15/12/29.
//  Copyright © 2015年 joinus. All rights reserved.
//
/**
 *  好友列表数据模型
 */

#import "BaseModel.h"

@interface FriendListModel : BaseModel

/**
 *  用户加密id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString * user_name;
/**
 *  用户手机号码
 */
@property(nonatomic,strong)NSString * user_mobile;
/**
 *  用户注册时间
 */
@property(nonatomic,strong)NSString * register_date;



@end
