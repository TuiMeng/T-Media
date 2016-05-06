//
//  MOrderCell.h
//  推盟
//
//  Created by joinus on 16/4/26.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieOrderListModel.h"

typedef void(^MOrderGetTicketCodeBlock)(NSString * orderId);

@interface MOrderCell : UITableViewCell{
    MOrderGetTicketCodeBlock getTicketCodeBlock;
    MovieOrderListModel * info;
}
/**
 *  背景视图
 */
@property(nonatomic,strong)UIView   * backContentView;
/**
 *  订单号
 */
@property(nonatomic,strong)UILabel  * orderIdLebel;
/**
 *  订单日期
 */
@property(nonatomic,strong)UILabel  * orderDateLabel;
/**
 *  分割线
 */
@property(nonatomic,strong)UIView   * lineView;
/**
 *  电影名称
 */
@property(nonatomic,strong)UILabel  * movieNameLabel;
/**
 *  影院名称
 */
@property(nonatomic,strong)UILabel  * cinemaNameLabel;
/**
 *  放映时间
 */
@property(nonatomic,strong)UILabel  * playDateLabel;
/**
 *  座位
 */
@property(nonatomic,strong)UILabel  * seatsLabel;
/**
 *  总金额
 */
@property(nonatomic,strong)UILabel  * totalMoneyLabel;
/**
 *  积分
 */
@property(nonatomic,strong)UILabel  * scoreNumLabel;
/**
 *  重新发送取票码
 */
@property(nonatomic,strong)UIButton * getCodeButton;
/**
 *  订单状态
 */
@property(nonatomic,strong)UILabel  * orderStatusLabel;


-(void)getTicketCodeClicked:(MOrderGetTicketCodeBlock)block;

-(void)setInfomationWithOrderModel:(MovieOrderListModel *)model;

@end
