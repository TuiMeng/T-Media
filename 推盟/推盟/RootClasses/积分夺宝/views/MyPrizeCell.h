//
//  MyPrizeCell.h
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrizeModel.h"
#import "TaskPrizeView.h"
#import "CLRollLabel.h"

//领取奖品
typedef void(^MyPrizeCellGetPrizeBlock)(PrizeStatusModel * pirzeModel);
//查看奖品
typedef void(^MyPrizeCellLookTaskContentBlock)(void);

@interface MyPrizeCell : UITableViewCell<TaskPrizeViewConvertDelegate>{
    MyPrizeCellGetPrizeBlock getBlock;
    MyPrizeCellLookTaskContentBlock lookBlock;
}

//背景视图
@property(nonatomic,strong)UIView           * backView;
//任务名称背景图
@property(nonatomic,strong)UIView           * titleView;
//奖品信息
@property(nonatomic,strong)TaskPrizeView    * prizeView;
//任务名称
@property(nonatomic,strong)UILabel          * taskNameLabel;
//点击/抽奖次数
@property(nonatomic,strong)UILabel          * clickAndLotteryNum;




-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model getPrizeBlock:(MyPrizeCellGetPrizeBlock)gBlock lookTaskContentBlock:(MyPrizeCellLookTaskContentBlock)lBlock;

@end
