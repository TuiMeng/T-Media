//
//  MyPrizeCell.h
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrizeModel.h"
//领取奖品
typedef void(^MyPrizeCellGetPrizeBlock)(void);
//查看奖品
typedef void(^MyPrizeCellLookTaskContentBlock)(void);

@interface MyPrizeCell : UITableViewCell{
    MyPrizeCellGetPrizeBlock getBlock;
    MyPrizeCellLookTaskContentBlock lookBlock;
}

//背景视图
@property(nonatomic,strong)UIView * backView;
//奖品名称背景图
@property(nonatomic,strong)UIView * titleView;
//奖品名称
@property(nonatomic,strong)UILabel * PrizeNameLabel;
//时间
@property(nonatomic,strong)UILabel * timeLabel;
//内容背景视图
@property(nonatomic,strong)UIView * contentBackView;
//内容标题
@property(nonatomic,strong)UILabel * contentLabel;
//点击次数
@property(nonatomic,strong)UILabel * clickedNumLabel;
//抽奖次数
@property(nonatomic,strong)UILabel * lotteryNumLabel;
//查看按钮
@property(nonatomic,strong)UIButton * lookButton;
//审核状态
@property(nonatomic,strong)UILabel * statusLabel;
//如果通过显示物流平台,如果拒绝显示拒绝原因
@property(nonatomic,strong)UILabel * platformLabel;




-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model getPrizeBlock:(MyPrizeCellGetPrizeBlock)gBlock lookTaskContentBlock:(MyPrizeCellLookTaskContentBlock)lBlock;

@end
