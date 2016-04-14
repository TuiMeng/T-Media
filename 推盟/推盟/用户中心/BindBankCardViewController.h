//
//  BindBankCardViewController.h
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/*
 **绑定修改银行卡支付宝界面
 */


#import <UIKit/UIKit.h>


@interface BindBankCardViewController : MyViewController{
    
}
/**
 *  判断银行卡还是支付宝  1为银行卡  0为支付宝
 */
@property(nonatomic,strong)NSString * card_type;

@end
