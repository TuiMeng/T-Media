//
//  ShareViewController.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/*
 **抢单(分享)界面
 */

#import <UIKit/UIKit.h>
#import "RootTaskListModel.h"

@interface ShareViewController : MyViewController
/**
 *  任务id
 */
@property(nonatomic,strong)RootTaskListModel * task_model;
@property(nonatomic,strong)NSString * task_id;
@property(nonatomic,strong)UIImage * shareImage;

@end
