//
//  TaskPrizeView.h
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//
/*
 * 针对某个任务，抽到的奖品视图
 */

#import <UIKit/UIKit.h>
#import "TaskPrizeCell.h"


@protocol TaskPrizeViewConvertDelegate <NSObject>

-(void)convertClicked:(NSString *)prizeId;

@end

@interface TaskPrizeView : UIView

@property(nonatomic,assign)id<TaskPrizeViewConvertDelegate> delegate;


-(void)setInfoWithArray:(NSMutableArray *)prizes;

@end
