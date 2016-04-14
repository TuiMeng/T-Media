//
//  TaskDetailViewController.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

/*
 **任务详情界面
 */

#import <UIKit/UIKit.h>
#import "RootTaskListModel.h"

@interface TaskDetailViewController : MyViewController

@property(nonatomic,strong)RootTaskListModel * task_model;

@end
