//
//  BasePrizeView.h
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePrizeView : UIView

///奖品名称
@property(nonatomic,strong)UILabel * name;
///日期
@property(nonatomic,strong)UILabel * date;
///展示信息1
@property(nonatomic,strong)UILabel * extra1;
///展示信息2
@property(nonatomic,strong)UILabel * extra2;
///兑换按钮
@property(nonatomic,strong)UIButton * convert;





@end
