//
//  MCardPayViewController.h
//  推盟
//
//  Created by joinus on 16/3/23.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  卡支付
 */

#import "MyViewController.h"

#define GRAY_BACKGROUND_COLOR RGBCOLOR(245,245,245)
#define LINE_COLOR RGBCOLOR(224,224,224)

typedef void(^MCarPaySelectedCardsBlock)(float payMoney,NSString * cardInfo,NSMutableArray * cardArray);

@interface MCardPayViewController : MyViewController{
    MCarPaySelectedCardsBlock cardBlock;
}
//
@property(nonatomic,strong)NSMutableDictionary  * payInfoDic;
@property(nonatomic,assign)int                  countDown;
@property(nonatomic,strong)NSString             * orderId;
@property(nonatomic,strong)NSString             * sign;
//需要支付的钱数
@property(nonatomic,assign)float                needPayPrice;
//之前添加的卡信息
@property(nonatomic,strong)NSMutableArray       * cardInfoArray;

-(void)chooseCardWith:(MCarPaySelectedCardsBlock)block;

@end
