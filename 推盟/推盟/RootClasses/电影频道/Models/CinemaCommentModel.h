//
//  CinemaCommentModel.h
//  推盟
//
//  Created by joinus on 16/3/18.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface CinemaCommentModel : BaseModel


/**
 *  评论id
 */
@property(nonatomic,strong)NSString * commentId;
/**
 *  用户id
 */
@property(nonatomic,strong)NSString * userId;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString * userName;
/**
 *  用户头像
 */
@property(nonatomic,strong)NSString * userImage;
/**
 *  评分
 */
@property(nonatomic,strong)NSString * score;
/**
 *  评论内容
 */
@property(nonatomic,strong)NSString * content;
/**
 *  日期
 */
@property(nonatomic,strong)NSString * date;



@end
