//
//  WinnerListCell.h
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinnerModel.h"

@interface WinnerListCell : UITableViewCell

//手机号
@property(nonatomic,strong)UILabel * mobileLabel;
//点击次数
@property(nonatomic,strong)UILabel * clickNumLabel;
//日期
@property(nonatomic,strong)UILabel * dateLabel;


-(void)setInfomationWithWinnerModel:(WinnerModel *)model;


@end
