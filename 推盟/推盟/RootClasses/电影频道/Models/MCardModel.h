//
//  MCardModel.h
//  推盟
//
//  Created by joinus on 16/3/29.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface MCardModel : BaseModel

/**
 *  手机号
 */
@property(nonatomic,strong)NSString     * phone;
/**
 *  性别
 */
@property(nonatomic,strong)NSString     * sex;
/**
 *  状态
 */
@property(nonatomic,strong)NSString     * status;
/**
 *  001,储值卡,0,储值卡,1
 *  002,计次卡,1,计次卡,30
 *  003,通票,2,一次性,10
 *  004,一票通,3,一次性,30
 *  005,建党九十年,4,一次性,
 *  006,影片一票通006,5,一次性,40
 *  007,影片一票通007,6,一次性,60
 *  008,影片一票通（计次）,7,一次性,60
 *  009,鸿泰团体01,,一次性,
 *  010,鸿泰团体02,,一次性,
 */
@property(nonatomic,strong)NSString     * tickettypeid;
/**
 *  类型
 */
@property(nonatomic,strong)NSString     * type;
/**
 *
 */
@property(nonatomic,strong)NSString     * ifreg;
/**
 *  父类型(储值卡/电影券)
 */
@property(nonatomic,strong)NSString     * parentType;
/**
 *  余额/剩余次数
 */
@property(nonatomic,strong)NSString     * curval;
/**
 *  兑换比例
 *  如果是计次卡,curval为5，表示剩余5次。localval为30，表示卡内剩余金额为5 * 30 = 150元。
 如果是储值卡，localval一般为1，curval为50则表示卡内剩余金额为50元
 */
@property(nonatomic,strong)NSString     * localval;
/**
 *
 */
@property(nonatomic,strong)NSString     * secretNo;
/**
 *  卡密码
 */
@property(nonatomic,strong)NSString     * orderNo;
/**
 *
 */
@property(nonatomic,strong)NSString     * address;
/**
 *
 */
@property(nonatomic,strong)NSString     * email;
/**
 *  卡号
 */
@property(nonatomic,strong)NSString     * sequenceNo;
/**
 *
 */
@property(nonatomic,strong)NSString     * useenddate;
/**
 *
 */
@property(nonatomic,strong)NSString     * newpwd;
/**
 *
 */
@property(nonatomic,strong)NSString     * result;
/**
 *  modify by sn  如果为兑换卡，记录被扣除的次数
 */
@property(nonatomic,assign)int          useCount;





@end
