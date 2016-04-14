//
//  RootViewController.h
//  推盟
//
//  Created by joinus on 15/7/28.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/*
 **首页（任务列表页）
 */

#import <UIKit/UIKit.h>
#import "CycleScrollModel.h"
#import "CycleScrollView.h"


@interface RootViewController : MyViewController


@property(nonatomic,strong)SDCycleScrollView * cycle_scrollView;


@end
