//
//  MCardPayCell.h
//  推盟
//
//  Created by joinus on 16/3/29.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCardModel.h"

typedef void(^MCardPayDoneBlock)(NSString * num,NSString * pw,BOOL isAdd);
typedef void(^MCardPayRemoveBlock)(void);

@interface MCardPayCell : UITableViewCell{
    MCardPayDoneBlock       doneBlock;
    MCardPayRemoveBlock     removeBlock;
}

@property(nonatomic,strong)SView            * backView;
@property(nonatomic,strong)SView            * separatorView1;
@property(nonatomic,strong)STextField       * cardNumTextField;
@property(nonatomic,strong)STextField       * cardPWTextField;
@property(nonatomic,strong)UILabel          * cardInfoLabel;
@property(nonatomic,strong)UIButton         * doneButton;
@property(nonatomic,strong)UIButton         * removeButton;

/**
 *  @param model 卡信息
 *  @param type  类型（0：票卡  1：计次卡 2：兑换券）
 *  @param price 需要支付的钱数
 */
-(void)setInfomationWithCardModel:(id)info WithType:(int)type withPrice:(float)price;

-(void)setPayDoneBlock:(MCardPayDoneBlock)dBlock remove:(MCardPayRemoveBlock)rBlock;


@end
