//
//  MTopicCommentModel.h
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  话题评论
 */

#import "BaseModel.h"

@interface MTopicCommentOrginModel : BaseModel{
    
}


@property(nonatomic,strong)NSString     * img;
@property(nonatomic,strong)NSString     * name;
@property(nonatomic,strong)NSString     * id;
@property(nonatomic,strong)NSString     * content;

@end




@interface MTopicCommentModel : BaseModel

@property(nonatomic,strong)NSString                 * img;
@property(nonatomic,strong)NSString                 * name;
@property(nonatomic,strong)NSString                 * id;
@property(nonatomic,strong)NSString                 * date;
@property(nonatomic,strong)NSString                 * content;
@property(nonatomic,strong)MTopicCommentOrginModel  * orginModel;


@end








