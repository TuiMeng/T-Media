//
//  RootTaskListTableViewCell.h
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTaskListModel.h"
#import "TaskInfo.h"

typedef void(^RootForwardBlock)(void);

@interface RootTaskListTableViewCell : UITableViewCell{
    RootForwardBlock forward_block;
}
/**
 *  北京视图
 */
@property (strong, nonatomic)UIView *background_view;
/**
 *  头图
 */
@property (strong, nonatomic) UIImageView *headerImageView;
/**
 *  标题
 */
@property (strong, nonatomic) SLabel *title_label;
/**
 *  奖金总额
 */
@property (strong, nonatomic) UILabel *bonus_label;
/**
 *  普通/高级用户单次点击钱数
 */
@property (strong, nonatomic) UILabel *system_label;
/**
 *  分享按钮
 */
@property (strong, nonatomic) UIButton *forward_button;
/**
 *  标签视图
 */
@property(nonatomic,strong)SLabel * tag_label;



- (IBAction)forwardButtonClicked:(id)sender;


-(void)setInfoWith:(RootTaskListModel *)model showTag:(BOOL)show WithShare:(RootForwardBlock)block;

@end
