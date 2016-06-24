//
//  PrizeShareViewController.h
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyViewController.h"

@interface PrizeShareViewController : MyViewController

//点击多少次可以抽奖一次
@property(nonatomic,strong)NSString * numForLotteryOnce;
//任务id
@property(nonatomic,strong)NSString * task_id;
//分享图片地址
@property(nonatomic,strong)NSString * shareImageUrl;

@end
