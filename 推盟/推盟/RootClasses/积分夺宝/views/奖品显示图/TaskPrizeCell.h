//
//  TaskPrizeCell.h
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrizeModel.h"

@class TaskPrizeCell;
///立即兑换
@protocol TaskPrizeCellConvertDelegate <NSObject>

-(void)convertClicked:(TaskPrizeCell *)cell;

@end


@interface TaskPrizeCell : UITableViewCell


///背景视图
@property(nonatomic,strong)UIView   * backV;
///奖品名称
@property(nonatomic,strong)UILabel  * name;
///日期
@property(nonatomic,strong)UILabel  * date;
///展示信息1
@property(nonatomic,strong)UILabel  * extra1;
///展示信息2
@property(nonatomic,strong)UILabel  * extra2;
///兑换按钮
@property(nonatomic,strong)UIButton * convert;

@property(nonatomic,assign) id<TaskPrizeCellConvertDelegate> delegate;

-(void)setInfomationWithPrizeModel:(PrizeStatusModel *)model;

@end
