//
//  LotteryView.h
//  推盟
//
//  Created by joinus on 16/6/15.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  抽奖界面
 */

#import <UIKit/UIKit.h>

typedef void(^LotteryViewConvertBlock)(void);
typedef void(^LotteryViewModifyAddressBlock)(void);
typedef void(^LotteryViewConvertBlock)(void);

@interface LotteryView : UIView{
    LotteryViewConvertBlock         convertBlock;
    LotteryViewModifyAddressBlock   modifyBlock;
}


+(instancetype)sharedInstance;

//开始动画
-(void)loadingAnimation;
/**
 *  中奖
 */
-(void)showWinnerViewWithPrizeName:(NSString *)name
                         isVirtual:(BOOL)isVirtual
                      convertBlock:(LotteryViewConvertBlock)cBlock
                       modifyBlock:(LotteryViewModifyAddressBlock)mBlock;
/**
 *  未中奖
 */
-(void)showFailedViewWithBackTap:(void(^)(void))back;

#pragma mark ------  设置收货地址
-(void)setupAddressWithAddressModel:(UserAddressModel *)address;

@end
